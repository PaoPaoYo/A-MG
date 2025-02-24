import CarInfo from './CarInfo'

export default interface CardInfo {
  formId?: string,
  cardStatus: number, // 0待初始化 1已初始化 2初始化失败 3正在更新
  carInfo?: CarInfo,
  mapImg?: PixelMap
}