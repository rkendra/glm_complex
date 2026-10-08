import gleam/float

pub type Complex {
  Complex(real: Float, imag: Float)
}

pub fn add(lhs: Complex, rhs: Complex) -> Complex {
  Complex(real: lhs.real +. rhs.real, imag: lhs.imag +. rhs.imag)
}

pub fn sub(lhs: Complex, rhs: Complex) -> Complex {
  Complex(real: lhs.real -. rhs.real, imag: lhs.imag -. rhs.imag)
}

pub fn multiply(lhs: Complex, rhs: Complex) -> Complex {
  let real1 = lhs.real *. rhs.real
  let real2 = lhs.imag *. rhs.imag
  let imag1 = lhs.real *. rhs.imag
  let imag2 = lhs.imag *. rhs.real
  Complex(real: real1 -. real2, imag: imag1 +. imag2)
}

pub fn to_string(num: Complex) {
  case num.real, num.imag {
    0.0, 0.0 -> "0i"
    x, 0.0 -> float.to_string(x)
    0.0, y -> float.to_string(y) <> "i"
    x, y if y <. 0.0 ->
      "(" <> float.to_string(x) <> "-" <> float.to_string(y *. -1.0) <> "i)"
    x, y -> "(" <> float.to_string(x) <> "+" <> float.to_string(y) <> "i)"
  }
}
