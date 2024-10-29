#import "@preview/valkyrie:0.2.1" as z

#let complex_schema = z.dictionary(( complex: z.number(), imaginary: z.number() ))
#let number_like_schema = z.either(
  z.either(z.number(), z.integer()),
  z.either(z.floating-point(), z.string())
)
#let all_number_like_schema = z.either(
  number_like_schema,
  complex_schema
)

#let to_number(x) = z.parse(x, number_like_schema)

#let to_complex(x) = all_number_like_schema

#let complex(real, imaginary) = (real: to_number(real), imaginary: to_number(imaginary))

#let add(a, b) = {
  let complex_a = z.parse(a, complex_schema)
  let complex_b = z.parse(b, complex_schema)
}