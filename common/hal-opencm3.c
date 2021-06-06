#include "hal.h"

#define SERIAL_BAUD 9600

#include <libopencm3/cm3/dwt.h>
#include <libopencm3/cm3/nvic.h>
#include <libopencm3/cm3/systick.h>
#if defined(LM3S)
#include <libopencm3/lm3s/gpio.h>
#include <libopencm3/lm3s/usart.h>

#define SERIAL_USART USART0_BASE
#define rng_enable() ((void)0)
#elif defined(STM32F215RET6)
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/usart.h>
#include <libopencm3/stm32/flash.h>
#include <libopencm3/stm32/rng.h>
/* TODO: Determine the right  */
#define SERIAL_GPIO GPIOA
#define SERIAL_USART USART1
#define SERIAL_PINS (GPIO9 | GPIO10)
#define STM32
#define CW_BOARD
#elif defined(STM32F207ZG)
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/usart.h>
#include <libopencm3/stm32/flash.h>
#include <libopencm3/stm32/rng.h>

#define SERIAL_GPIO GPIOD
#define SERIAL_USART USART3
#define SERIAL_PINS (GPIO8 | GPIO9)
#define STM32
#define NUCLEO_BOARD
#elif defined(STM32L100RCT6)
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/usart.h>
#include <libopencm3/stm32/flash.h>
#define rng_enable() ((void)0)

#define SERIAL_GPIO GPIOA
#define SERIAL_USART USART2
#define SERIAL_PINS (GPIO2 | GPIO3)
#define STM32
#define STM32L1DISCO_BOARD
#elif defined(SAM3X8E)
#include <libopencm3/sam/gpio.h>
#include <libopencm3/sam/pmc.h>
#include <libopencm3/sam/eefc.h>
#include <libopencm3/sam/uart.h>
#include <libopencm3/sam/wdt.h>

#define SERIAL_PIO PIOA
#define SERIAL_PINS ((1 << 8) | (1 << 9))
#define MCLK 12000000lu
#define rng_enable() ((void)0)
#else
#error Unsupported libopencm3 board
#endif

#define _RCC_CAT(A, B) A ## _ ## B
#define RCC_ID(NAME) _RCC_CAT(RCC, NAME)

static uint32_t _clock_freq;

#ifdef STM32F2
extern uint32_t rcc_apb1_frequency;
extern uint32_t rcc_apb2_frequency;
#endif

#if defined(LM3S)
// TODO(dsprenkels) Currently, we only exit the QEMU host when a the program
// exists sucessfully.  We should also populate some interrupts handlers that
// occur on errors and/or other exception.

// These two syscall values are used at the end of the program, when we want
// to tell the QEMU host that we are done.  I took them from
// <https://github.com/rust-embedded/cortex-m-semihosting/blob/8ab74cdb8c9ab669ded328072447ea6f6054ffe6/src/debug.rs#L25-L50>.
static const uint32_t REPORT_EXCEPTION = 0x18;
static const uint32_t ApplicationExit = 0x20026;

// Do a system call towards QEMU or the debugger.
static uint32_t semihosting_syscall(uint32_t nr, const uint32_t arg) {
	__asm__ volatile (
		"mov r0, %[nr]\n"
		"mov r1, %[arg]\n"
		"bkpt 0xAB\n"
		"mov %[nr], r0\n"
	: [nr] "+r" (nr) : [arg] "r" (arg) : "0", "1");
	return nr;
}

// Register a destructor that will call qemu telling them that the program
// has exited successfully.
static void __attribute__ ((destructor)) semihosting_exit(void) {
	semihosting_syscall(REPORT_EXCEPTION, ApplicationExit);
}
#endif /* defined(LM3S) */

static void clock_setup(enum clock_mode clock)
{
#if defined(LM3S)
  /* Nothing todo */
  /* rcc_clock_setup_in_xtal_8mhz_out_50mhz(); */
#elif defined(STM32F2)
  /* Some STM32 Platform */
  rcc_periph_clock_enable(RCC_RNG);
  rcc_periph_clock_enable(RCC_GPIOH);
  /* All of them use an external oscillator with bypass. */
  rcc_osc_off(RCC_HSE);
  rcc_osc_bypass_enable(RCC_HSE);
  rcc_osc_on(RCC_HSE);
  rcc_wait_for_osc_ready(RCC_HSE);

#if defined(CW_BOARD)
  rcc_ahb_frequency = 7372800;
  rcc_apb1_frequency = 7372800;
  rcc_apb2_frequency = 7372800;
  _clock_freq = 7372800;
  rcc_set_hpre(RCC_CFGR_HPRE_DIV_NONE);
  rcc_set_ppre1(RCC_CFGR_PPRE_DIV_NONE);
  rcc_set_ppre2(RCC_CFGR_PPRE_DIV_NONE);
  rcc_set_sysclk_source(RCC_CFGR_SW_HSE);
  rcc_wait_for_sysclk_status(RCC_HSE);
#elif defined(NUCLEO_BOARD)
  /* NUCLEO-STM32F2 Board */
  switch (clock) {
  case CLOCK_BENCHMARK:
    rcc_ahb_frequency = 30000000;
    rcc_apb1_frequency = 30000000;
    rcc_apb2_frequency = 30000000;
    _clock_freq = 30000000;
    rcc_set_hpre(RCC_CFGR_HPRE_DIV_4);
    rcc_set_ppre1(RCC_CFGR_PPRE_DIV_NONE);
    rcc_set_ppre2(RCC_CFGR_PPRE_DIV_NONE);
    rcc_osc_off(RCC_PLL);
    /* Configure the PLL oscillator (use CUBEMX tool). */
    rcc_set_main_pll_hse(8, 240, 2, 5);
    /* Enable PLL oscillator and wait for it to stabilize. */
    rcc_osc_on(RCC_PLL);
    rcc_wait_for_osc_ready(RCC_PLL);
    flash_dcache_enable();
    flash_icache_enable();
    flash_set_ws(FLASH_ACR_LATENCY_0WS);
    flash_prefetch_enable();
    break;
  case CLOCK_FAST:
  default:
    rcc_ahb_frequency = 120000000;
    rcc_apb1_frequency = 30000000;
    rcc_apb2_frequency = 60000000;
    _clock_freq = 120000000;
    rcc_set_hpre(RCC_CFGR_HPRE_DIV_NONE);
    rcc_set_ppre1(RCC_CFGR_PPRE_DIV_4);
    rcc_set_ppre2(RCC_CFGR_PPRE_DIV_2);
    rcc_osc_off(RCC_PLL);
    /* Configure the PLL oscillator (use CUBEMX tool). */
    rcc_set_main_pll_hse(8, 240, 2, 5);
    /* Enable PLL oscillator and wait for it to stabilize. */
    rcc_osc_on(RCC_PLL);
    rcc_wait_for_osc_ready(RCC_PLL);
    flash_dcache_enable();
    flash_icache_enable();
    flash_set_ws(FLASH_ACR_LATENCY_3WS);
    flash_prefetch_enable();
    break;
  }
  rcc_set_sysclk_source(RCC_CFGR_SW_PLL);
  rcc_wait_for_sysclk_status(RCC_PLL);
#else
#error Unsupported STM32F2 Board
#endif
#elif defined(STM32L1DISCO_BOARD)
  rcc_osc_on(RCC_HSI);
  rcc_wait_for_osc_ready(RCC_HSI);
  rcc_ahb_frequency = 16000000;
  rcc_apb1_frequency = 16000000;
  rcc_apb2_frequency = 16000000;
  _clock_freq = 16000000;
  rcc_set_hpre(RCC_CFGR_HPRE_SYSCLK_NODIV);
  rcc_set_ppre1(RCC_CFGR_PPRE1_HCLK_NODIV);
  rcc_set_ppre2(RCC_CFGR_PPRE2_HCLK_NODIV);
  rcc_periph_clock_enable(RCC_PWR);
  pwr_set_vos_scale(PWR_SCALE1);
  flash_64bit_enable();
  flash_prefetch_enable();
  flash_set_ws(0);
  rcc_osc_off(RCC_PLL);
  rcc_set_pll_configuration(RCC_CFGR_PLLSRC_HSI_CLK, RCC_CFGR_PLLMUL_MUL3, RCC_CFGR_PLLDIV_DIV3);
  rcc_osc_on(RCC_PLL);
  rcc_wait_for_osc_ready(RCC_PLL);
  rcc_set_sysclk_source(RCC_CFGR_SW_SYSCLKSEL_PLLCLK);
#elif defined(SAM3X8E)
  WDT_CR = WDT_CR_KEY | WDT_CR_WDRSTT;
  WDT_MR = WDT_MR_WDDIS | WDT_MR_WDDBGHLT | WDT_MR_WDIDLEHLT;
	pmc_peripheral_clock_enable(6);
	pmc_peripheral_clock_enable(7);
  CKGR_MOR = (CKGR_MOR & ~CKGR_MOR_MOSCRCF_MASK) | CKGR_MOR_MOSCRCF_12MHZ | CKGR_MOR_KEY;
  /* Without the FAM its *slightly* faster, but the Chip Manual says that with 0
     WS we need the FAM? (but still works without...) */
  EEFC_FMR(EEFC0) = EEFC_FMR_FAM | (EEFC_FMR_FWS_MASK & (0 << 8));
  EEFC_FMR(EEFC1) = EEFC_FMR_FAM | (EEFC_FMR_FWS_MASK & (0 << 8));
  /* Disable the Watchdog */
#else
#error Unsupported platform
#endif
}

void usart_setup()
{
#if defined(LM3S)
  /* Nothing todo for the simulator... */
#elif defined(STM32)
  /* The should be pretty much the same for all STM32 Boards */
#  if defined(STM32F207ZG)
  rcc_periph_clock_enable(RCC_GPIOD);
  rcc_periph_clock_enable(RCC_USART3);
  gpio_set_output_options(SERIAL_GPIO, GPIO_OTYPE_OD, GPIO_OSPEED_100MHZ, SERIAL_PINS);
#  elif defined(STM32L100RCT6)
  rcc_periph_clock_enable(RCC_GPIOA);
  rcc_periph_clock_enable(RCC_USART2);
  gpio_set_output_options(SERIAL_GPIO, GPIO_OTYPE_OD, GPIO_OSPEED_40MHZ, SERIAL_PINS);
  gpio_set_af(SERIAL_GPIO, GPIO_AF7, SERIAL_PINS);
#  else
  rcc_periph_clock_enable(RCC_GPIOA);
  rcc_periph_clock_enable(RCC_USART1);
  gpio_set_output_options(SERIAL_GPIO, GPIO_OTYPE_OD, GPIO_OSPEED_100MHZ, SERIAL_PINS);
#  endif
  gpio_mode_setup(SERIAL_GPIO, GPIO_MODE_AF, GPIO_PUPD_PULLUP, SERIAL_PINS);
  gpio_set_af(SERIAL_GPIO, GPIO_AF7, SERIAL_PINS);
  usart_set_baudrate(SERIAL_USART, SERIAL_BAUD);
  usart_set_databits(SERIAL_USART, 8);
  usart_set_stopbits(SERIAL_USART, USART_STOPBITS_1);
  usart_set_mode(SERIAL_USART, USART_MODE_TX_RX);
  usart_set_parity(SERIAL_USART, USART_PARITY_NONE);
  usart_set_flow_control(SERIAL_USART, USART_FLOWCONTROL_NONE);
  usart_disable_rx_interrupt(SERIAL_USART);
  usart_disable_tx_interrupt(SERIAL_USART);
  usart_enable(SERIAL_USART);
#elif defined(SAM3X8E)
	pmc_peripheral_clock_enable(11);
	pmc_peripheral_clock_enable(8);
	gpio_init(PIOA, SERIAL_PINS, GPIO_FLAG_PERIPHA | GPIO_FLAG_PULL_UP);
  UART_CR = UART_CR_RSTRX | UART_CR_RSTTX | UART_CR_RXDIS | UART_CR_TXDIS;
  UART_MR = UART_MR_PAR_NO | UART_MR_CHMODE_NORMAL;
	UART_BRGR = (MCLK / SERIAL_BAUD) >> 4;
  UART_IDR = ~0;
  UART_CR = UART_CR_RXEN | UART_CR_TXEN;
#endif
}

void systick_setup()
{
  /* Systick is always the same on libopencm3 */
  systick_set_clocksource(STK_CSR_CLKSOURCE_AHB);
  systick_set_reload(0xFFFFFFu);
  systick_interrupt_enable();
  systick_counter_enable();
}

void hal_setup(const enum clock_mode clock)
{
  clock_setup(clock);
  usart_setup();
  systick_setup();
  rng_enable();
}

void hal_send_str(const char* in)
{
#if defined(SAM3X8E)
  const char* cur = in;
  while(*cur) {
    while((UART_SR & UART_SR_TXRDY) == 0);
    UART_THR = *cur;
    cur += 1;
  }
  while((UART_SR & UART_SR_TXRDY) == 0);
  UART_THR = '\n';
#else
  const char* cur = in;
  while (*cur) {
    usart_send_blocking(SERIAL_USART, *cur);
    cur += 1;
  }
  usart_send_blocking(SERIAL_USART, '\n');
#endif
}

static volatile unsigned long long overflowcnt = 0;

void sys_tick_handler(void)
{
  ++overflowcnt;
}

uint64_t hal_get_time()
{
  while (true) {
    unsigned long long before = overflowcnt;
    unsigned long long result = (before + 1) * 16777216llu - systick_get_value();
    if (overflowcnt == before) {
      return result;
    }
  }
}

/* End of BSS is where the heap starts (defined in the linker script) */
extern char end;
static char* heap_end = &end;

void* __wrap__sbrk (int incr)
{
  char* prev_heap_end;

  prev_heap_end = heap_end;
  heap_end += incr;

  return (void *) prev_heap_end;
}

size_t hal_get_stack_size(void)
{
  register char* cur_stack;
	__asm__ volatile ("mov %0, sp" : "=r" (cur_stack));
  return cur_stack - heap_end;
}
