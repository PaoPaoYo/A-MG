export interface VehiclePosition {
  satellites: number;
  altitude: number;
  latitude: string;
  gps_status: number;
  update_time: number;
  gps_time: number;
  hdop: number;
  longitude: string;
}

export interface VehicleAlerts {
}

export interface VehicleSecurity {
  position_authorization_status: boolean;
  privacy_status: boolean;
}

export interface VehicleValue {
  climate_on_off_status: boolean | null;
  steer_heat_level: number | null;
  rear_right_tyre_pressure: number;
  inst_fuel_consumption: number | null;
  battery_pack_fault_status: boolean | null;
  tbox_internal_battery: number | null;
  charge_door_position_status: boolean | null;
  veh_bms_pack_soc_dsp_v: number | null;
  battery_lattice_number: number;
  driving_range: number;
  battery_pack_range: number;
  power_mode: number;
  engine_status: number;
  exterior_temperature: number;
  rmt_rr_seat_heat_flr_rsn: string | null;
  localfront_left_seat_heat_level: number | null;
  fuel_level_prc: number;
  interior_pm25: number;
  odometer: number;
  local_sec_row_l_seat_heat_lvl: number | null;
  rmt_fr_seat_heat_flr_rsn: string | null;
  inspect_status: string | null;
  remote_steer_heat_level: number | null;
  last_key_seen: number;
  wheel_tyre_monitor_status: string | null;
  rmt_a_c_abot_rsn: string | null;
  vehicle_battery: number;
  chrgng_rmnng_time_v: number | null;
  exterior_pm25: number;
  front_left_tyre_pressure: number;
  charge_status: number;
  speed: number;
  front_right_tyre_pressure: number;
  vehicle_battery_dev: number;
  battery_pack_prc: number;
  interior_temperature_v: number | null;
  steer_heat_failure_reason: string | null;
  local_sec_row_r_seat_heat_lvl: number | null;
  clstr_elec_rng_to_eptv: number | null;
  fuel_range: number;
  current_journey_id: number;
  interior_temperature: number;
  localfront_right_seat_heat_level: number | null;
  heading: number;
  battery_alarm_value: number[];
  update_time: number;
  remote_climate_status: number;
  fota_status: number;
  current_journey_distance: number;
  bms_charge_status: boolean | null;
  vehicle_alarm_status: number;
  rear_left_tyre_pressure: number;
  vehicle_battery_prc: number;
  battery_type: number;
  fuel_level_disp: number;
  monitor_status: string | null;
  chrgng_rmnng_time: number | null;
}

export interface VehicleState {
  door: boolean;
  gnss_ant_connected: boolean;
  second_row_left_seat_heat: boolean;
  gsm_ant_connected: boolean;
  rear_right_door: boolean;
  dipped_beam: boolean;
  driver_window: boolean;
  vehicle_battery_connected: boolean;
  clstr_range: boolean;
  battery_pack: boolean;
  driver_door: boolean;
  seat_heat: boolean;
  engine: boolean;
  second_row_right_seat_heat: boolean;
  lock: boolean;
  power: boolean;
  boot: boolean;
  right_seat_heat: boolean;
  charge: boolean;
  passenger_door: boolean;
  can_bus: boolean;
  monitor: boolean | null;
  update_time: number;
  climate: boolean;
  left_seat_heat: boolean;
  feed: boolean;
  horn: boolean;
  air_clean: boolean;
  light: boolean;
  bonnet: boolean;
  rear_right_window: boolean;
  sunroof: boolean;
  bat_low: boolean | null;
  inspect: boolean | null;
  rear_left_door: boolean;
  passenger_window: boolean;
  window: boolean;
  side_light: boolean;
  rear_left_window: boolean;
  main_beam: boolean;
}

interface VehicleDetail {
  vehicle_position: VehiclePosition;
  vehicle_alerts: VehicleAlerts[];
  vehicle_security: VehicleSecurity;
  vehicle_value: VehicleValue;
  update_time: number;
  vehicle_state: VehicleState;
}

export interface VehicleData {
  req_id: string;
  data: VehicleDetail;
}

interface pinStatusList {
  config_status: number;
  config_type: number;
  user_id: null | number;
  device_id: string;
}

export interface BoundVinListRoewe {
  vehicle_series_id: number;
  series_code: null | string;
  series_name: string;
  relation_list: string[];
  is_new_real_name: null | boolean;
  pin_status_list: pinStatusList[];
  relation: string;
  vehicle_no: string;
  model_name: string;
  phone_number: string;
  whether_real_name_authentication: boolean;
  byod_show_type: string;
  vehicle_project_code: string;
  vin: string;
  is_lite: boolean;
  byod_version: string;
  vehicle_pin_code_flag: boolean;
  realname_status: number;
}

interface VinDataData {
  bound_vin_list_roewe: BoundVinListRoewe[];
}

export interface VinData {
  req_id: string;
  data: VinDataData;
}
