#let to_number(x) = {
  if type(x) == "decimal" { return x }
  if type(x) == "float" { return x }
  if type(x) == "integer" { return x }
  assert(false, "Number must be either decimal, float, or integer.")
}

#let complex(real, imag) = (
  real: to_number(real),
  imag: to_number(imag)
)

#let to_complex(x) = {
  if type(x) == "dictionary" { return x }
  return complex(to_number(x), 0)
}

#let add(a, b) = {
  let complex_a = to_complex(a)
  let complex_b = to_complex(b)

  return complex(
    complex_a.real + complex_b.real,
    complex_a.imag + complex_b.imag
  )
}

#let mul(na, nb) = {
  let complex_a = to_complex(na)
  let complex_b = to_complex(nb)

  let a = complex_a.real
  let b = complex_a.imag
  let c = complex_b.real
  let d = complex_b.imag

  // https://stackoverflow.com/a/25728515/7589775
  let k1 = c * (a + b)
  let k2 = a * (d - c)
  let k3 = b * (c + d)

  return complex(
    k1 - k3,
    k1 + k2
  )
}

// https://stackoverflow.com/a/58996103/7589775
#let div(na, nb) = {
  let complex_a = to_complex(na)
  let complex_b = to_complex(nb)

  let a = complex_a.real
  let b = complex_a.imag
  let c = complex_b.real
  let d = complex_b.imag

  if calc.abs(d) < calc.abs(c) {
    let doc = d / c
    return complex(
      (a + b * doc) / (c + d * doc),
      (b - a * doc) / (c + d * doc)
    )
  } else {
    let cod = c / d
    return complex(
      (b + a * cod) / (d + c * cod),
      (-a + b * cod) / (d + c * cod)
    )
  }
}

#let abs(x) = {
  let complex_x = to_complex(x)

  return calc.sqrt(
    calc.pow(complex_x.real, 2) +
    calc.pow(complex_x.imag, 2)
  )
}

#let eq(a, b) = {
  let complex_a = to_complex(a)
  let complex_b = to_complex(b)

  return a.real == b.real and a.imag == b.imag
}

// a^b
#let pow(norm_a, norm_b) = {
  // from https://github.com/rawify/Complex.js/blob/main/src/complex.js
  let a = to_complex(norm_a)
  let b = to_complex(norm_b)
  let aIsZero = eq(a, complex(0, 0))
  let bIsZero = eq(b, complex(0, 0))

  if (bIsZero) {
    return complex(1, 0)
  }

  // If the exponent is real
  if b.imag == 0 {
    if a.imag == 0 and a.real > 0 {
      return complex(calc.pow(a.real, b.real), 0)
    } else if a.real == 0 { // If base is fully imaginary
      let inter = calc.rem(calc.rem(b.real, 4) + 4, 4)
      if inter == 0 {
        return complex(calc.pow(a.imag, b.real), 0)
      } else if inter == 1 {
        return complex(0, calc.pow(a.imag, b.real))
      } else if inter == 2 {
        return complex(-calc.pow(a.imag, b.real), 0)
      } else if inter == 3 {
        return complex(0, -calc.pow(a.imag, b.real))
      }
    }
  }

  if (aIsZero and b.real > 0) { // Same behavior as Wolframalpha, Zero if real part is zero
    return complex(0, 0)
  }

  let arg = calc.atan2(a.real, a.imag).rad()
  let loh = calc.log(abs(a), base: calc.e)

  let re = calc.exp(b.real * loh - b.imag * arg)
  let im = b.imag * loh + b.real * arg
  return complex(
    re * calc.cos(im),
    re * calc.sin(im)
  )
}

#let neg(x) = mul(x, complex(-1, 0))
