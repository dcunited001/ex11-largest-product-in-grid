## Project Euler - [Problem 11](http://projecteuler.net/problem=11)

To run:

```bash
bundle install
ruby ex11.rb
```

> taking a 20x20 matrix as input,
> find the highest product of four consecutive, adjacent indexes

I took a brute force approach to solving the problem.
Just multiplying the matrices out and finding the max.

This approach to solving the problem could be simply modified to return
the product's factors and their location, though it's not ensured to be a
unique location or set of factors.

There's probably smarter or more efficient solutions to the problem.
There are alot of zero's in the input, so each zero has a 8-pointed star of
zero-products surrounding it.  Excluding those parts of the matrix from being calculated
could shave some time off the algorithm.

It may also be possibly to use a factor-based approach to the problem, using a
sieving-like approach and filtering out indexes from consideration which contain
factors too low to be possible solutions.  But I'm not sure how much time these approaches
would save over the the brute force method for a simple 20x20 matrix.
