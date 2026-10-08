import gleeunit
import glm_complex

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn to_string_test() {
  let real_only = glm_complex.Complex(3.14, 0.0)
  let imag_only = glm_complex.Complex(0.0, 2.34)
  let both = glm_complex.Complex(4.54, 2.34)
  let negative_imag = glm_complex.Complex(4.6, -1.23)
  let zero = glm_complex.Complex(0.0, 0.0)
  assert glm_complex.to_string(real_only) == "3.14"
  assert glm_complex.to_string(imag_only) == "2.34i"
  assert glm_complex.to_string(both) == "(4.54+2.34i)"
  assert glm_complex.to_string(negative_imag) == "(4.6-1.23i)"
  assert glm_complex.to_string(zero) == "0i"
}

/// Test basic imaginary number multiplications
pub fn powers_of_i_test() {
  let i = glm_complex.Complex(0.0, 1.0)
  assert glm_complex.multiply(i, i) == glm_complex.Complex(-1.0, 0.0)
}
