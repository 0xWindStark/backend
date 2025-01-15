#[derive(Drop, Copy, Serde, Introspect)]
pub struct Coordinates {
    pub x: u32,
    pub y: u32,
}
