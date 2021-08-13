# Speed Evaluation
## Key Encapsulation Schemes
| scheme | implementation | key generation [cycles] | encapsulation [cycles] | decapsulation [cycles] |
| ------ | -------------- | ----------------------- | ---------------------- | ---------------------- |
| firesaber (100 executions) | clean | AVG: 4,008,689 <br /> MIN: 4,008,682 <br /> MAX: 4,008,721 | AVG: 4,978,241 <br /> MIN: 4,978,231 <br /> MAX: 4,978,270 | AVG: 5,765,705 <br /> MIN: 5,765,693 <br /> MAX: 5,765,732 |
| firesaber (100 executions) | m3speed | AVG: 1,498,378 <br /> MIN: 1,498,375 <br /> MAX: 1,498,415 | AVG: 1,811,994 <br /> MIN: 1,811,991 <br /> MAX: 1,812,032 | AVG: 1,882,251 <br /> MIN: 1,882,247 <br /> MAX: 1,882,288 |
| firesaber (100 executions) | m3stack | AVG: 2,024,392 <br /> MIN: 2,024,388 <br /> MAX: 2,024,428 | AVG: 2,484,693 <br /> MIN: 2,484,688 <br /> MAX: 2,484,728 | AVG: 2,554,683 <br /> MIN: 2,554,678 <br /> MAX: 2,554,719 |
| lightsaber (100 executions) | clean | AVG: 1,238,485 <br /> MIN: 1,238,482 <br /> MAX: 1,238,522 | AVG: 1,800,793 <br /> MIN: 1,800,789 <br /> MAX: 1,800,829 | AVG: 2,196,876 <br /> MIN: 2,196,871 <br /> MAX: 2,196,912 |
| lightsaber (100 executions) | m3speed | AVG: 519,952 <br /> MIN: 519,951 <br /> MAX: 519,990 | AVG: 706,161 <br /> MIN: 706,160 <br /> MAX: 706,200 | AVG: 747,411 <br /> MIN: 747,410 <br /> MAX: 747,450 |
| lightsaber (100 executions) | m3stack | AVG: 613,896 <br /> MIN: 613,895 <br /> MAX: 613,934 | AVG: 862,174 <br /> MIN: 862,173 <br /> MAX: 862,212 | AVG: 903,685 <br /> MIN: 903,684 <br /> MAX: 903,725 |
| saber (100 executions) | clean | AVG: 2,612,797 <br /> MIN: 2,612,792 <br /> MAX: 2,612,832 | AVG: 3,437,602 <br /> MIN: 3,437,595 <br /> MAX: 3,437,635 | AVG: 3,916,240 <br /> MIN: 3,916,232 <br /> MAX: 3,916,271 |
| saber (100 executions) | m3speed | AVG: 960,237 <br /> MIN: 960,236 <br /> MAX: 960,277 | AVG: 1,217,099 <br /> MIN: 1,217,097 <br /> MAX: 1,217,137 | AVG: 1,266,793 <br /> MIN: 1,266,790 <br /> MAX: 1,266,830 |
| saber (100 executions) | m3stack | AVG: 1,228,688 <br /> MIN: 1,228,685 <br /> MAX: 1,228,725 | AVG: 1,589,456 <br /> MIN: 1,589,453 <br /> MAX: 1,589,495 | AVG: 1,639,161 <br /> MIN: 1,639,158 <br /> MAX: 1,639,198 |
## Signature Schemes
| scheme | implementation | key generation [cycles] | sign [cycles] | verify [cycles] |
| ------ | -------------- | ----------------------- | ------------- | --------------- |
# Memory Evaluation
## Key Encapsulation Schemes
| Scheme | Implementation | Key Generation [bytes] | Encapsulation [bytes] | Decapsulation [bytes] |
| ------ | -------------- | ---------------------- | --------------------- | --------------------- |
| firesaber | clean | 19,364 | 19,468 | 20,940 |
| firesaber | m3speed | 7,692 | 8,372 | 8,372 |
| firesaber | m3stack | 4,324 | 3,340 | 3,364 |
| lightsaber | clean | 9,448 | 9,552 | 10,288 |
| lightsaber | m3speed | 5,636 | 6,308 | 6,308 |
| lightsaber | m3stack | 3,292 | 3,076 | 3,356 |
| saber | clean | 13,040 | 13,168 | 14,232 |
| saber | m3speed | 6,668 | 7,348 | 7,348 |
| saber | m3stack | 3,812 | 3,212 | 3,364 |
## Signature Schemes
| Scheme | Implementation | Key Generation [bytes] | Sign [bytes] | Verify [bytes] |
| ------ | -------------- | ---------------------- | ------------ | -------------- |
# Hashing Evaluation
## Key Encapsulation Schemes
| Scheme | Implementation | Key Generation [%] | Encapsulation [%] | Decapsulation [%] |
| ------ | -------------- | ------------------ | ----------------- | ----------------- |
| firesaber | clean | 18.1% | 18.2% | 13.1% |
| firesaber | m3speed | 52.3% | 53.3% | 43.2% |
| firesaber | m3stack | 38.7% | 38.9% | 31.8% |
| lightsaber | clean | 22.7% | 21.8% | 14.1% |
| lightsaber | m3speed | 54.1% | 55.7% | 41.4% |
| lightsaber | m3stack | 45.8% | 45.6% | 34.2% |
| saber | clean | 19.8% | 19.6% | 13.2% |
| saber | m3speed | 53.9% | 55.1% | 43.1% |
| saber | m3stack | 42.1% | 42.2% | 33.3% |
## Signature Schemes
| Scheme | Implementation | Key Generation [%] | Sign [%] | Verify [%] |
| ------ | -------------- | ------------------ | -------- | ---------- |
# Size Evaluation
## Key Encapsulation Schemes
| Scheme | Implementation | .text [bytes] | .data [bytes] | .bss [bytes] | Total [bytes] |
| ------ | -------------- | ------------- | ------------- | ------------ | ------------- |
| firesaber | clean | 10,332 | 0 | 0 | 10,332 |
| firesaber | m3speed | 30,780 | 0 | 0 | 30,780 |
| firesaber | m3stack | 30,760 | 0 | 0 | 30,760 |
| lightsaber | clean | 10,500 | 0 | 0 | 10,500 |
| lightsaber | m3speed | 30,968 | 0 | 0 | 30,968 |
| lightsaber | m3stack | 31,016 | 0 | 0 | 31,016 |
| saber | clean | 10,240 | 0 | 0 | 10,240 |
| saber | m3speed | 30,688 | 0 | 0 | 30,688 |
| saber | m3stack | 30,700 | 0 | 0 | 30,700 |
## Signature Schemes
| Scheme | Implementation | .text [bytes] | .data [bytes] | .bss [bytes] | Total [bytes] |
| ------ | -------------- | ------------- | ------------- | ------------ | ------------- |
