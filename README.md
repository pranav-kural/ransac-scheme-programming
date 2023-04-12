# RANSAC in Scheme

Implementation of RANSAC dominant plane detection algorithm in Scheme programming language

## Usage

This project has been developed using [DrRacket IDE](https://racket-lang.org/). To run the project, open the file `test.rkt` in DrRacket and press `Run`.

The `run-tests` function defines all the tests that can be run.

You can comment-out the tests you don't want to run.

```scheme
; Main test function
(define (run-tests)
  (test-read)
  (test-diff)
  (test-plane)
  (test-distance)
  (test-support)
  (test-num-iterations)
  (test-ransac)
  )
; initiate the tests
(run-tests)
```

### Sample Output

<img width="532" alt="image" src="https://user-images.githubusercontent.com/17651852/231602017-2c638910-9b6d-4e31-bee1-f6ef14f100b6.png">
