// mod interfaces {

// }

mod models {
    pub mod coordinates;
    pub mod corridor;
    pub mod enemy_position;
    pub mod enemy;
    pub mod player_position;
    pub mod player_state;
    pub mod scene;
    pub mod trail;
}

mod systems {
    pub mod end;
    pub mod move;
    pub mod start;
}

mod utils {
    pub mod coordinates_to_felt;
}
