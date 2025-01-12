#[derive(Drop, Copy, Serde, Introspect)]
pub struct Coordinates {
    x: u8,
    y: u8
}