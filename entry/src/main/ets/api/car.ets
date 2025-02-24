import axios, { AxiosResponse } from "@ohos/axios"
import CarInfo from "../type/CarInfo"
import { BoundVinListRoewe, VehicleData, VinData } from "./car.d"
import dayjs from 'dayjs'

const URL_GET_INFO = 'https://mp.ebanma.com/app-mp/vp/1.2/getVehicleStatus'
const URL_UPDATE_INFO = 'https://mp.ebanma.com/app-mp/vp/1.1/requestVehicleStatus'
const URL_VIN = 'https://mp.ebanma.com/app-mp/user/4.4/findBoundVinList'

export default function getCarInfo(token: string) {
  return new Promise<CarInfo>((resolve, reject) => {
      getCarBaseInfo(token).then((baseInfo: BoundVinListRoewe) => {
        updateCar(token, baseInfo.vin).then(() => {
        axios.get<VehicleData, AxiosResponse<VehicleData>, null>(URL_GET_INFO, {
          params: {
            token: token,
            vin: baseInfo.vin
          }
        }).then((res: AxiosResponse<VehicleData>) => {
          if (res.status === 200) {
            resolve({
              updateTime: dayjs().format('YYYY-MM-DD HH:mm:ss'),
              rawUpdateTime: dayjs(res.data.data.update_time).format('YYYY-MM-DD HH:mm:ss'),
              carNo: baseInfo.vehicle_no,
              vin: baseInfo.vin,
              modelName: baseInfo.model_name,
              remainingMileage: res.data.data.vehicle_value.driving_range,
              fuelLevel: res.data.data.vehicle_value.fuel_level_prc,
              batteryLevel: res.data.data.vehicle_value.vehicle_battery_prc,
              odometer: res.data.data.vehicle_value.odometer,
              interiorTemperature: res.data.data.vehicle_value.interior_temperature,
              exteriorTemperature: res.data.data.vehicle_value.exterior_temperature,
              tirePressure: [
                res.data.data.vehicle_value.front_left_tyre_pressure,
                res.data.data.vehicle_value.front_right_tyre_pressure,
                res.data.data.vehicle_value.rear_left_tyre_pressure,
                res.data.data.vehicle_value.rear_right_tyre_pressure,
              ],
              sunroof: res.data.data.vehicle_state.sunroof,
              light: res.data.data.vehicle_state.light,
              window: [
                res.data.data.vehicle_state.driver_window,
                res.data.data.vehicle_state.passenger_window,
                res.data.data.vehicle_state.rear_left_window,
                res.data.data.vehicle_state.rear_right_window,
              ],
              door: [
                res.data.data.vehicle_state.driver_door,
                res.data.data.vehicle_state.passenger_door,
                res.data.data.vehicle_state.rear_left_door,
                res.data.data.vehicle_state.rear_right_door,
              ],
              boot: res.data.data.vehicle_state.boot,
              lock: res.data.data.vehicle_state.lock,
              longitude: res.data.data.vehicle_position.longitude,
              latitude: res.data.data.vehicle_position.latitude
            })
          } else {
            reject()
          }
        })
          .catch((error: Error) => {
            reject(error)
          })
          .catch((error: Error) => {
            reject(error)
          })
      })
    })
      .catch((e: Error) => {
        reject(e)
      })
  })
}

export function getVehicleData(token: string, vin: string) {
  return new Promise<VehicleData>((resolve, reject) => {
    axios.get<VehicleData, AxiosResponse<VehicleData>, null>(URL_GET_INFO, {
      params: {
        token,
        vin
      }
    }).then((res: AxiosResponse<VehicleData>) => {
      if (res.status === 200) {
        resolve(res.data)
      } else {
        reject()
      }
    })
      .catch((error: Error) => {
        reject(error)
      })
  })
}

export function getCarBaseInfo(token: string) {
  return new Promise<BoundVinListRoewe>((resolve, reject) => {
    axios.get<VinData, AxiosResponse<VinData>, null>(URL_VIN, {
      params: {
        token: token,
        appId: 'MG'
      }
    }).then((res: AxiosResponse<VinData>) => {
      if (res.status === 200 && res.data.data.bound_vin_list_roewe && res.data.data.bound_vin_list_roewe.length > 0) {
        resolve(res.data.data.bound_vin_list_roewe[0])
      } else {
        reject()
      }
    })
      .catch((error: Error) => {
        reject(error)
      })
  })
}

export function updateCar(token: string, vin: string) {
  return new Promise<void>((resolve, reject) => {
    axios.get<VinData, AxiosResponse<VinData>, null>(URL_UPDATE_INFO, {
      params: {
        token: token,
        vin,
        timestamp: new Date().getTime() / 1000
      }
    }).then((res: AxiosResponse<VinData>) => {
      if (res.status === 200) {
        resolve()
      } else {
        reject()
      }
    })
      .catch((error: Error) => {
        reject(error)
      })
  })
}