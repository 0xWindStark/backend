use windstark::models::coordinates::Coordinates;

pub fn coordinates_to_felt(coordinates: @Coordinates) -> felt252 {
    let x = coordinates.x.deref();
    let y = coordinates.y.deref();
    let index = 15 * y + x;

    let mut felt: felt252 = 1;
    for _a in 0..index {
        felt = felt * 2
    };

    return felt;
}
