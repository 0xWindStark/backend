#[derive(Drop, Copy, Serde, Introspect)]
pub struct Coordinates {
    x: u32,
    y: u32
}