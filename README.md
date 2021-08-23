# AssameseASR
ASR on Assamese Language using Kaldi

## Number Syster WERs
| Best Model Name | Pass | WER | Error | ins | del | sub |
| --------------- | --------------- | --------------- | --------------- | --------------- | --------------- | --------------- |
| Monophone | 15_1.0 | 4.46 | 200 / 4480 | 92 | 18 | 90 |
| tri1 : Deltas + Delta-Deltas | 12_1.0 | 0.29 | 13 / 4480 | 2 | 9 | 2 |
| tri1 : Deltas + Delta-Deltas | 10_0.0 | 0.29 | 13 / 4480 | 2 | 8 | 3 |
| tri2 : LDA + MLLT | 14_1.0 | 0.31 | 14 / 4480 | 1 | 10 | 3 |
| tri3 : LDA + MLLT + SAT | 10_0.0 | 0.27 | 12 / 4480 | 0 | 10 | 2 |
