export default interface CarInfo {
  // 更新时间
  updateTime?: string;
  // 原始数据更新时间
  rawUpdateTime?: string;
  // 车牌号
  carNo?: string;
  // VIN
  vin?: string;
  // 型号
  modelName?: string;
  // 剩余里程
  remainingMileage?: number;
  // 油量
  fuelLevel?: number;
  // 电量
  batteryLevel?: number;
  // 总里程
  odometer?: number;
  // 车内温度
  interiorTemperature?: number;
  // 车外温度
  exteriorTemperature?: number;
  // 胎压 分别是 左前 右前 左后 右后
  tirePressure?: [number, number, number, number];
  // 天窗状态
  sunroof?: boolean;
  // 车窗状态 左前 右前 左后 右后
  window?: [boolean, boolean, boolean, boolean];
  // 车门状态 左前 右前 左后 右后
  door?: [boolean, boolean, boolean, boolean];
  // 后备箱状态
  boot?: boolean;
  // 锁车状态
  lock?: boolean;
  // 经纬度
  longitude?: string;
  latitude?: string;
  // 灯光
  light?: boolean
}