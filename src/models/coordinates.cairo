#[derive(Drop, Copy, Serde, Introspect, PartialEq)]
pub struct Coordinates {
    pub x: u32,
    pub y: u32,
}
