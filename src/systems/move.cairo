#[starknet::interface]
trait IMoveAction<T> {
    fn move(ref self: T, direction: u8);
}

#[dojo::contract]
mod move_action {
    use super::IMoveAction;
    use starknet::{get_caller_address};
    use windstark::models::{
        coordinates::Coordinates, player_position::PlayerPosition, scene::Scene, trail::Trail,
        player_state::PlayerState,
    };
    use windstark::utils::coordinates_to_felt::coordinates_to_felt;
    use dojo::model::{ModelStorage};

    #[abi(embed_v0)]
    impl MoveActionImpl of IMoveAction<ContractState> {
        fn move(ref self: ContractState, direction: u8) {
            let mut world = self.world_default();
            let player = get_caller_address();

            if direction >= 1 && direction <= 8 {
                self._move_player(direction);

                let player_pos: PlayerPosition = world.read_model(player);
                let trail: Trail = world.read_model(player);
                let path = trail.path;

                let mut state: bool = false;

                for pos in path {
                    if pos == player_pos.pos {
                        state = true;
                        break;
                    }
                };

                world.write_model(@PlayerState { player, state });
            }
            self._move_enemy();
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"windstark")
        }

        fn check_big_pos_availablity(
            self: @ContractState, coordinates: Coordinates,
        ) -> (bool, bool, bool, bool, bool, bool, bool, bool) {
            let mut world = self.world_default();
            let player = get_caller_address();
            let scene: Scene = world.read_model(player);
            let map: u256 = scene.map.into();

            let pos_1 = Coordinates { x: coordinates.x, y: coordinates.y + 1 };
            let pos_2 = Coordinates { x: coordinates.x + 1, y: coordinates.y + 1 };
            let pos_3 = Coordinates { x: coordinates.x + 1, y: coordinates.y };
            let pos_4 = Coordinates { x: coordinates.x + 1, y: coordinates.y - 1 };
            let pos_5 = Coordinates { x: coordinates.x, y: coordinates.y - 1 };
            let pos_6 = Coordinates { x: coordinates.x - 1, y: coordinates.y - 1 };
            let pos_7 = Coordinates { x: coordinates.x - 1, y: coordinates.y };
            let pos_8 = Coordinates { x: coordinates.x - 1, y: coordinates.y + 1 };

            let felt_1: u256 = coordinates_to_felt(@pos_1).into();
            let felt_2: u256 = coordinates_to_felt(@pos_2).into();
            let felt_3: u256 = coordinates_to_felt(@pos_3).into();
            let felt_4: u256 = coordinates_to_felt(@pos_4).into();
            let felt_5: u256 = coordinates_to_felt(@pos_5).into();
            let felt_6: u256 = coordinates_to_felt(@pos_6).into();
            let felt_7: u256 = coordinates_to_felt(@pos_7).into();
            let felt_8: u256 = coordinates_to_felt(@pos_8).into();

            let is_free_1 = (map & felt_1 == felt_1);
            let is_free_2 = (map & felt_2 == felt_2);
            let is_free_3 = (map & felt_3 == felt_3);
            let is_free_4 = (map & felt_4 == felt_4);
            let is_free_5 = (map & felt_5 == felt_5);
            let is_free_6 = (map & felt_6 == felt_6);
            let is_free_7 = (map & felt_7 == felt_7);
            let is_free_8 = (map & felt_8 == felt_8);

            return (
                is_free_1,
                is_free_2,
                is_free_3,
                is_free_4,
                is_free_5,
                is_free_6,
                is_free_7,
                is_free_8,
            );
        }

        fn _move_player(ref self: ContractState, direction: u8) {
            let mut world = self.world_default();
            let player = get_caller_address();

            let old_player: PlayerPosition = world.read_model(player);

            let old_player_pos = old_player.pos;
            let old_player_big_pos = old_player.big_pos;
            let old_player_small_pos = old_player.small_pos;

            let (
                is_free_1,
                is_free_2,
                is_free_3,
                is_free_4,
                is_free_5,
                is_free_6,
                is_free_7,
                is_free_8,
            ) =
                self
                .check_big_pos_availablity(
                    Coordinates { x: old_player_big_pos.x, y: old_player_big_pos.y },
                );

            let mut new_player_pos = old_player_pos;
            let mut new_player_big_pos = old_player_big_pos;
            let mut new_player_small_pos = old_player_small_pos;

            let mut moved: bool = false;

            if direction == 1 {
                if old_player_small_pos.y == 4 {
                    if is_free_1 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x, y: old_player_pos.y + 1 };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x, y: old_player_big_pos.y + 1 };
                        new_player_small_pos = Coordinates { x: old_player_small_pos.x, y: 0 };
                        moved = true;
                    }
                } else {
                    new_player_pos = Coordinates { x: old_player_pos.x, y: old_player_pos.y + 1 };
                    new_player_small_pos =
                        Coordinates { x: old_player_small_pos.x, y: old_player_small_pos.y + 1 };
                    moved = true;
                }
            } else if direction == 2 {
                if old_player_small_pos.x == 4 && old_player_small_pos.y == 4 {
                    if is_free_1 & is_free_2 & is_free_3 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y + 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x + 1, y: old_player_big_pos.y + 1,
                            };
                        new_player_small_pos = Coordinates { x: 0, y: 0 };
                        moved = true;
                    } else if is_free_3 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x + 1, y: old_player_big_pos.y };
                        new_player_small_pos = Coordinates { x: 0, y: 4 };
                        moved = true;
                    } else if is_free_1 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x, y: old_player_pos.y + 1 };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x, y: old_player_big_pos.y + 1 };
                        new_player_small_pos = Coordinates { x: 4, y: 0 };
                        moved = true;
                    }
                } else if old_player_small_pos.x == 4 {
                    if is_free_3 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y + 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x + 1, y: old_player_big_pos.y + 1,
                            };
                        new_player_small_pos = Coordinates { x: 0, y: old_player_small_pos.y + 1 };
                        moved = true;
                    } else {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x, y: old_player_pos.y + 1 };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x, y: old_player_big_pos.y + 1 };
                        new_player_small_pos = Coordinates { x: 4, y: old_player_small_pos.y + 1 };
                        moved = true;
                    }
                } else if old_player_small_pos.y == 4 {
                    if is_free_1 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y + 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x + 1, y: old_player_big_pos.y + 1,
                            };
                        new_player_small_pos = Coordinates { x: old_player_small_pos.x + 1, y: 0 };
                        moved = true;
                    } else {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x + 1, y: old_player_big_pos.y };
                        new_player_small_pos = Coordinates { x: old_player_small_pos.x + 1, y: 4 };
                        moved = true;
                    }
                } else {
                    new_player_pos =
                        Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y + 1 };
                    new_player_small_pos =
                        Coordinates {
                            x: old_player_small_pos.x + 1, y: old_player_small_pos.y + 1,
                        };
                    moved = true;
                }
            } else if direction == 3 {
                if old_player_small_pos.x == 4 {
                    if is_free_3 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x + 1, y: old_player_big_pos.y };
                        new_player_small_pos = Coordinates { x: 0, y: old_player_small_pos.y };
                        moved = true;
                    }
                } else {
                    new_player_pos = Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y };
                    new_player_small_pos =
                        Coordinates { x: old_player_small_pos.x + 1, y: old_player_small_pos.y };
                    moved = true;
                }
            } else if direction == 4 {
                if old_player_small_pos.x == 4 && old_player_small_pos.y == 0 {
                    if is_free_3 & is_free_4 & is_free_5 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y - 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x + 1, y: old_player_big_pos.y - 1,
                            };
                        new_player_small_pos = Coordinates { x: 0, y: 4 };
                        moved = true;
                    } else if is_free_3 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x + 1, y: old_player_big_pos.y };
                        new_player_small_pos = Coordinates { x: 0, y: 0 };
                        moved = true;
                    } else if is_free_5 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x, y: old_player_pos.y - 1 };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x, y: old_player_big_pos.y - 1 };
                        new_player_small_pos = Coordinates { x: 4, y: 4 };
                        moved = true;
                    }
                } else if old_player_small_pos.x == 4 {
                    if is_free_3 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y - 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x + 1, y: old_player_big_pos.y - 1,
                            };
                        new_player_small_pos = Coordinates { x: 0, y: old_player_small_pos.y - 1 };
                        moved = true;
                    } else {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x, y: old_player_pos.y - 1 };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x, y: old_player_big_pos.y - 1 };
                        new_player_small_pos = Coordinates { x: 4, y: old_player_small_pos.y - 1 };
                        moved = true;
                    }
                } else if old_player_small_pos.y == 0 {
                    if is_free_5 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y - 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x + 1, y: old_player_big_pos.y - 1,
                            };
                        new_player_small_pos = Coordinates { x: old_player_small_pos.x + 1, y: 4 };
                        moved = true;
                    } else {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x + 1, y: old_player_big_pos.y };
                        new_player_small_pos = Coordinates { x: old_player_small_pos.x + 1, y: 0 };
                        moved = true;
                    }
                } else {
                    new_player_pos =
                        Coordinates { x: old_player_pos.x + 1, y: old_player_pos.y - 1 };
                    new_player_small_pos =
                        Coordinates {
                            x: old_player_small_pos.x + 1, y: old_player_small_pos.y - 1,
                        };
                    moved = true;
                }
            } else if direction == 5 {
                if old_player_small_pos.y == 0 {
                    if is_free_5 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x, y: old_player_pos.y - 1 };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x, y: old_player_big_pos.y - 1 };
                        new_player_small_pos = Coordinates { x: old_player_small_pos.x, y: 4 };
                        moved = true;
                    }
                } else {
                    new_player_pos = Coordinates { x: old_player_pos.x, y: old_player_pos.y - 1 };
                    new_player_small_pos =
                        Coordinates { x: old_player_small_pos.x, y: old_player_small_pos.y - 1 };
                    moved = true;
                }
            } else if direction == 6 {
                if old_player_small_pos.x == 0 && old_player_small_pos.y == 0 {
                    if is_free_5 & is_free_6 & is_free_7 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y - 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x - 1, y: old_player_big_pos.y - 1,
                            };
                        new_player_small_pos = Coordinates { x: 4, y: 4 };
                        moved = true;
                    } else if is_free_5 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x, y: old_player_pos.y - 1 };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x, y: old_player_big_pos.y - 1 };
                        new_player_small_pos = Coordinates { x: 0, y: 4 };
                        moved = true;
                    } else if is_free_7 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x - 1, y: old_player_big_pos.y };
                        new_player_small_pos = Coordinates { x: 4, y: 0 };
                        moved = true;
                    }
                } else if old_player_small_pos.x == 0 {
                    if is_free_7 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y - 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x - 1, y: old_player_big_pos.y - 1,
                            };
                        new_player_small_pos = Coordinates { x: 4, y: old_player_small_pos.y - 1 };
                        moved = true;
                    } else {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x, y: old_player_pos.y - 1 };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x, y: old_player_big_pos.y - 1 };
                        new_player_small_pos = Coordinates { x: 0, y: old_player_small_pos.y - 1 };
                        moved = true;
                    }
                } else if old_player_small_pos.y == 0 {
                    if is_free_5 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y - 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x - 1, y: old_player_big_pos.y - 1,
                            };
                        new_player_small_pos = Coordinates { x: old_player_small_pos.x - 1, y: 4 };
                        moved = true;
                    } else {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x - 1, y: old_player_big_pos.y };
                        new_player_small_pos = Coordinates { x: old_player_small_pos.x - 1, y: 0 };
                        moved = true;
                    }
                } else {
                    new_player_pos =
                        Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y - 1 };
                    new_player_small_pos =
                        Coordinates {
                            x: old_player_small_pos.x - 1, y: old_player_small_pos.y - 1,
                        };
                    moved = true;
                }
            } else if direction == 7 {
                if old_player_small_pos.x == 0 {
                    if is_free_7 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x - 1, y: old_player_big_pos.y };
                        new_player_small_pos = Coordinates { x: 4, y: old_player_small_pos.y };
                        moved = true;
                    }
                } else {
                    new_player_pos = Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y };
                    new_player_small_pos =
                        Coordinates { x: old_player_small_pos.x - 1, y: old_player_small_pos.y };
                    moved = true;
                }
            } else if direction == 8 {
                if old_player_small_pos.x == 0 && old_player_small_pos.y == 4 {
                    if is_free_1 & is_free_8 & is_free_7 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y + 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x - 1, y: old_player_big_pos.y + 1,
                            };
                        new_player_small_pos = Coordinates { x: 4, y: 0 };
                        moved = true;
                    } else if is_free_1 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x, y: old_player_pos.y + 1 };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x, y: old_player_big_pos.y + 1 };
                        new_player_small_pos = Coordinates { x: 0, y: 0 };
                        moved = true;
                    } else if is_free_7 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x - 1, y: old_player_big_pos.y };
                        new_player_small_pos = Coordinates { x: 4, y: 4 };
                        moved = true;
                    }
                } else if old_player_small_pos.x == 0 {
                    if is_free_7 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y + 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x - 1, y: old_player_big_pos.y + 1,
                            };
                        new_player_small_pos = Coordinates { x: 4, y: old_player_small_pos.y + 1 };
                        moved = true;
                    } else {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x, y: old_player_pos.y + 1 };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x, y: old_player_big_pos.y + 1 };
                        new_player_small_pos = Coordinates { x: 0, y: old_player_small_pos.y + 1 };
                        moved = true;
                    }
                } else if old_player_small_pos.y == 4 {
                    if is_free_1 {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y + 1 };
                        new_player_big_pos =
                            Coordinates {
                                x: old_player_big_pos.x - 1, y: old_player_big_pos.y + 1,
                            };
                        new_player_small_pos = Coordinates { x: old_player_small_pos.x - 1, y: 0 };
                        moved = true;
                    } else {
                        new_player_pos =
                            Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y };
                        new_player_big_pos =
                            Coordinates { x: old_player_big_pos.x - 1, y: old_player_big_pos.y };
                        new_player_small_pos = Coordinates { x: old_player_small_pos.x - 1, y: 4 };
                        moved = true;
                    }
                } else {
                    new_player_pos =
                        Coordinates { x: old_player_pos.x - 1, y: old_player_pos.y + 1 };
                    new_player_small_pos =
                        Coordinates {
                            x: old_player_small_pos.x - 1, y: old_player_small_pos.y + 1,
                        };
                    moved = true;
                }
            }

            if moved {
                let new_player_position = PlayerPosition {
                    player,
                    small_pos: new_player_small_pos,
                    big_pos: new_player_big_pos,
                    pos: new_player_pos,
                };

                let trail: Trail = world.read_model(player);
                let mut path = trail.path;
                path.append(old_player_pos);

                if path.len() > 6 {
                    let _a = path.pop_front().unwrap();
                }

                world.write_model(@new_player_position);
                world.write_model(@Trail { player, path });
            }
        }

        fn _move_enemy(ref self: ContractState) {}
    }
}
