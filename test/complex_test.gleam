import complex
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn to_string_test() {
  let real_only = complex.Complex(3.14, 0.0)
  let imag_only = complex.Complex(0.0, 2.34)
  let both = complex.Complex(4.54, 2.34)
  let negative_imag = complex.Complex(4.6, -1.23)
  let zero = complex.Complex(0.0, 0.0)
  assert complex.to_string(real_only) == "3.14"
  assert complex.to_string(imag_only) == "2.34i"
  assert complex.to_string(both) == "(4.54+2.34i)"
  assert complex.to_string(negative_imag) == "(4.6-1.23i)"
  assert complex.to_string(zero) == "0i"
}
