# AssameseASR
ASR on Assamese Language using Kaldi

## Number Syster WERs

System Configuration - MacOS 11.5.1, 8GB RAM, i5

Run on CPU

| Best Model Name | Pass | WER | Error | ins | del | sub | Time (s) |
| --------------- | --------------- | --------------- | --------------- | --------------- | --------------- | --------------- | --------------- |
| Monophone | 15_1.0 | 4.46 | 200 / 4480 | 92 | 18 | 90 | 200 |
| Monophone - 2 | 15_1.0 | 4.46 | 200 / 4480 | 92 | 18 | 90 | 1478 |
| tri1 : Deltas + Delta-Deltas | 12_1.0 | 0.29 | 13 / 4480 | 2 | 9 | 2 | 1431 |
| tri1 : Deltas + Delta-Deltas | 10_0.0 | 0.29 | 13 / 4480 | 2 | 8 | 3 | 1431 |
| tri2 : LDA + MLLT | 14_1.0 | 0.31 | 14 / 4480 | 1 | 10 | 3 | 868 |
| tri3 : LDA + MLLT + SAT | 10_0.0 | 0.27 | 12 / 4480 | 0 | 10 | 2 | 1296 |
| DNN hybrid | 17_1.0 | 3.04 | 136 / 4480 | 116 | 7 | 13 | 2164 |

