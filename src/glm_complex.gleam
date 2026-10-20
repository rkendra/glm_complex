//// A native Gleam implematation of complex numbers
////
//// Provides the Complex type, which represents a single complex number
//// and functions for working with complex numbers
////
//// As with floats, exceeding the maximum (or minimum) representable value
//// for a component of a complex number results in target-defined behavior
////
//// As Gleam does not support custom operators, all arithmetic operations must
//// be done via functions

import gleam/float
import gleam/int
import gleam/result
import gleam_community/maths

pub type Complex {
  Complex(real: Float, imag: Float)
}

/// Adds two complex numbers together
pub fn add(lhs: Complex, with rhs: Complex) -> Complex {
  Complex(real: lhs.real +. rhs.real, imag: lhs.imag +. rhs.imag)
}

/// Subtracts one complex number from another
pub fn subtract(lhs: Complex, rhs: Complex) -> Complex {
  Complex(real: lhs.real -. rhs.real, imag: lhs.imag -. rhs.imag)
}

/// Multiplies two complex numbers together
pub fn multiply(lhs: Complex, by rhs: Complex) -> Complex {
  case rhs {
    Complex(_, 0.0) -> scale(lhs, rhs.real)
    _ -> {
      let real1 = lhs.real *. rhs.real
      let real2 = lhs.imag *. rhs.imag
      let imag1 = lhs.real *. rhs.imag
      let imag2 = lhs.imag *. rhs.real
      Complex(real: real1 -. real2, imag: imag1 +. imag2)
    }
  }
}

/// Returns divison of the inputs as a Result
///
/// Returns an Error if the divisor is equivalent to 0.0
pub fn divide(dividend: Complex, by divisor: Complex) -> Result(Complex, Nil) {
  case divisor {
    Complex(0.0, 0.0) -> Error(Nil)
    _ -> {
      // Avoid multiplication if divisor has no imaginary component
      let #(numerator, denominator) = case divisor {
        Complex(_, 0.0) -> #(dividend, divisor.real)
        _ -> #(
          multiply(dividend, conjugate(divisor)),
          multiply(divisor, conjugate(divisor)).real,
        )
      }

      Ok(Complex(numerator.real /. denominator, numerator.imag /. denominator))
    }
  }
}

/// Returns the principal square root of the input as a Complex
/// using the formula as described [here](https://en.wikipedia.org/wiki/Square_root#Algebraic_formula)
///
/// Unlike int.square_root and float.square_root, this function
/// is infalliable as complex numbers are algebraically closed
pub fn square_root(num: Complex) -> Complex {
  let abs = absolute_value(num)
  let real =
    float.add(abs, num.real)
    |> float.multiply(0.5)
    |> float.square_root()
    |> result.unwrap(0.0)
  let imag =
    float.subtract(abs, num.real)
    |> float.multiply(0.5)
    |> float.square_root()
    |> result.unwrap(0.0)
  let imag_sign = case num.imag <. 0.0 {
    True -> -1.0
    False -> 1.0
  }
  Complex(real, imag *. imag_sign)
}

pub fn absolute_value(num: Complex) -> Float {
  let real_squared = num.real *. num.real
  let imag_squared = num.imag *. num.imag

  float.square_root(real_squared +. imag_squared)
  |> result.lazy_unwrap(fn() { panic as "This should never fail!" })
}

pub fn from_int(num: Int) -> Complex {
  Complex(int.to_float(num), 0.0)
}

pub fn from_float(num: Float) -> Complex {
  Complex(num, 0.0)
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

pub fn conjugate(num: Complex) -> Complex {
  Complex(num.real, num.imag *. -1.0)
}

pub fn negate(num: Complex) -> Complex {
  Complex(num.real *. -1.0, num.imag *. -1.0)
}

/// Returns the polar representation of a complex number in the form
/// (magnitude, theta)
pub fn to_polar(num: Complex) -> #(Float, Float) {
  let magnitude = absolute_value(num)
  let normalized =
    divide(num, from_float(magnitude))
    |> result.unwrap(Complex(0.0, 0.0))
  let theta =
    maths.acos(normalized.real)
    |> result.unwrap(0.0)
  #(magnitude, theta)
}

pub fn from_polar(magnitude: Float, theta: Float) -> Complex {
  let euler_result = Complex(maths.cos(theta), maths.sin(theta))
  Complex(euler_result.real *. magnitude, euler_result.imag *. magnitude)
}

/// Returns e (Euler's number) raised to the power of the given exponent, as a Complex
pub fn exponential(num: Complex) -> Complex {
  let euler_result = Complex(maths.cos(num.imag), maths.sin(num.imag))
  let real_exp = float.exponential(num.real)
  scale(euler_result, real_exp)
}

fn scale(c: Complex, scalar: Float) {
  Complex(c.real *. scalar, c.imag *. scalar)
}
