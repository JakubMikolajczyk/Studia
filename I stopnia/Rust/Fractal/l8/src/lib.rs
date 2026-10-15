mod utils;

use wasm_bindgen::prelude::*;

// When the `wee_alloc` feature is enabled, use `wee_alloc` as the global
// allocator.
#[cfg(feature = "wee_alloc")]
#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

use std::ops::{Add, Mul, Sub};

#[derive(Debug, Copy, Clone, PartialEq)]
pub struct Complex {
    pub(crate) a: f64,
    pub(crate) b: f64,

}

impl Add for Complex {
    type Output = Self;

    fn add(self, rhs: Self) -> Self {
        Self { a: self.a + rhs.a, b: self.b + rhs.b }
    }
}

impl Sub for Complex {
    type Output = Self;

    fn sub(self, rhs: Self) -> Self {
        Self { a: self.a - rhs.a, b: self.b - rhs.b }
    }
}


impl Mul for Complex {
    type Output = Self;

    fn mul(self, rhs: Self) -> Self::Output {
        Self {
            a: self.a * rhs.a - self.b * rhs.b,
            b: self.a * rhs.b + self.b * rhs.a,
        }
    }
}

#[wasm_bindgen]
pub struct Fractal{
    width: u32,
    height: u32,
    tab: Vec<u32>
}

#[wasm_bindgen]
impl Fractal{
    
    pub fn new() ->Fractal{
        let width = 1024;
        let height = 1024;
        let temp = width * height;
        let tab = vec![0; temp as usize];

        Fractal{
            width,
            height,
            tab,
        }
    }

    pub fn width(&self) -> u32 {
        self.width
    }

    pub fn height(&self) -> u32 {
        self.height
    }

    pub fn tab(&self) -> *const u32 {
        self.tab.as_ptr()
    }

    pub fn getIndex(&self,x:u32, y:u32) ->usize{
        (y * self.height + x )as usize
    }

    fn isMandelbrotSet(&self, x:f64, y:f64) -> f64{
        
        let mut  z = Complex {a:0.0, b:0.0};
        let scaled = Complex{a: x, b: y};

        let maxIter = 1000;
        let mut iteration = 0;

        while (z.a * z.a + z.b * z.b < 4.0) && iteration < maxIter {

            z = z * z + scaled;
            iteration+=1;
        }

        iteration as f64 - (z.a * z.a + z.b * z.b ).sqrt().log2().log2()
    }

    pub fn render(&mut self,xmin:f64, xmax:f64, ymin:f64, ymax:f64) -> Vec<u8>{

        let mut img = vec![];

        for y in 0..self.height{
            for x in  0..self.width{

                let index = self.getIndex(x, y);
                let val = self.isMandelbrotSet(
                    (xmax - xmin)/1024.0 * x as f64 + xmin,
                    (ymax - ymin)/1024.0 * y as f64 + ymin);
                    img.push(((0.016 * val + 4.0).sin() * 230.0 + 25.0) as u8);
                    img.push(((0.013 * val + 2.0).sin() * 230.0 + 25.0) as u8);
                    img.push(((0.01 * val + 1.0).sin() * 230.0 + 25.0) as u8);
                    img.push(255);
                }
        }

        img
    }
}
