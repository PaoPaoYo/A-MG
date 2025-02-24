import CardInfo from '../../type/CardInfo'
import CarInfo from '../../type/CarInfo'
import dayjs from 'dayjs'
import CarModel from '../../components/CarModel'

const cardInfo: CardInfo = {
  formId: '',
  cardStatus: 0,
  carInfo: {}
}
let storage: LocalStorage = new LocalStorage(cardInfo);

@Entry(storage)
@Component
struct AMGCard {
  @LocalStorageProp('formId') formId: string = '';
  @LocalStorageProp('cardStatus') cardStatus: number = 0;
  @LocalStorageProp('carInfo') carInfo: CarInfo = {};
  // 最近更新时间 显示方式
  @State timeMode: boolean = true
  // 是否显示胎压
  @State showTirePressure: boolean = false
  // 是否显示电池电量
  @State showBatteryPrc: boolean = false

  build() {
    Stack() {
      Column() {
        Column() {
          Row() {
            Text(this.carInfo.modelName || '车辆信息')
              .fontWeight(700)
            SymbolGlyph($r('sys.symbol.arrow_clockwise'))
              .fontSize(12)
              .fontWeight(700)
              .fontColor([$r('sys.color.ohos_id_color_text_secondary')])
              .transition(TransitionEffect.OPACITY.animation({ curve: Curve.Ease, duration: 200 }))
              .opacity(.5)
          }
          .width('100%')
          .onClick(() => {
            this.showTirePressure = false
            this.updateCarInfo()
          })

          Row() {
            Text(this.carInfo.carNo || ' ')
              .fontSize('12vp')
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          }
          .width('100%')
          .onClick(() => {
            this.showTirePressure = false
            this.updateCarInfo()
          })
        }
        .width('100%')

        Column() {
          Row() {
            Text(this.showBatteryPrc ? '电池电量' : `剩余里程`)
              .fontSize('12vp')
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          }
          .width('100%')
          .onClick(() => {
            if (this.showBatteryPrc) {
              this.showBatteryPrc = false
            } else {
              this.showBatteryPrc = true
            }
          })

          Row() {
            Text(String((this.showBatteryPrc ? ((this.carInfo.batteryLevel || 0) / 10) :
            this.carInfo.remainingMileage) || '0'))
              .fontSize('22vp')
              .fontWeight(700)
            Text(this.showBatteryPrc ? '%' : 'km')
              .fontSize('12vp')
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
              .margin({ bottom: '2vp', left: '2vp' })
          }
          .width('100%')
          .alignItems(VerticalAlign.Bottom)
          .onClick(() => {
            if (this.showBatteryPrc) {
              this.showBatteryPrc = false
            } else {
              this.showBatteryPrc = true
            }
          })

          Row() {
            Progress({
              value: this.showBatteryPrc ? ((this.carInfo.batteryLevel || 0) / 10) : this.carInfo.fuelLevel || 0,
              total: 100,
              type: ProgressType.Linear
            })
              .width('38%')
              .color((this.showBatteryPrc ? ((this.carInfo.batteryLevel || 0) / 10) : this.carInfo.fuelLevel || 0) <
                10 ? $r('sys.color.warning')
                : (this.showBatteryPrc ? ((this.carInfo.batteryLevel || 0) / 10) : this.carInfo.fuelLevel || 0) < 30 ?
                $r('sys.color.alert')
                  : (this.showBatteryPrc ? ((this.carInfo.batteryLevel || 0) / 10) : this.carInfo.fuelLevel || 0) < 80 ?
                  $r('sys.color.brand') : $r('sys.color.confirm'))
          }
          .width('100%')

          Row() {
            Text('总里程: ')
              .fontSize('14vp')
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            Text((this.carInfo.odometer || '0') + 'km')
              .fontSize('14vp')
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          }
          .width('100%')
          .margin({ top: '1%' })
          .alignItems(VerticalAlign.Bottom)

          Row() {
            Text(this.carInfo.lock ? '已上锁' : this.carInfo.lock == false ? '未上锁' : '')
              .fontSize('14vp')
              .fontColor(this.carInfo.lock ? $r('sys.color.brand') :
              $r('sys.color.warning'))
              .margin({ right: this.carInfo.lock !== undefined ? '8vp' : undefined })
            Text('更新时间: ' +
              (this.timeMode ? dayjs(this.carInfo.rawUpdateTime).format('MM-DD HH:mm') :
                dayjs().diff(dayjs(this.carInfo.rawUpdateTime), 'h') == 0 ?
                  (dayjs().diff(dayjs(this.carInfo.rawUpdateTime), 'm') + '分钟前')
                  : (dayjs().diff(dayjs(this.carInfo.rawUpdateTime), 'h'))
                  + '小时前'))
              .fontSize('12vp')
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
              .onClick(() => {
                this.timeMode = !this.timeMode
              })
          }
          .width('100%')
          .margin({ top: '1%' })
          .alignItems(VerticalAlign.Bottom)
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .padding({
        top: 12,
        right: 12,
        bottom: 10,
        left: 12
      })
      .backgroundColor($r('sys.color.ohos_id_color_background'))
      .justifyContent(FlexAlign.SpaceBetween)

      Stack() {
        if (this.cardStatus == 1) {
          CarModel({
            trunk: this.carInfo.boot,
            hood: false,
            light: this.carInfo.light,
            skyWindow: this.carInfo.sunroof,
            door: this.carInfo.door,
            window: this.carInfo.window,
            wheels: this.carInfo.tirePressure ? [this.carInfo.tirePressure[0] < 180,
              this.carInfo.tirePressure[1] < 180,
              this.carInfo.tirePressure[2] < 180,
              this.carInfo.tirePressure[3] < 180] : [false, false, false, false]
          })
            .width('110%')
            .rotate({
              angle: '45deg'
            })
            .position({ right: -30, top: 30 })
            .transition(TransitionEffect.asymmetric(
              TransitionEffect.translate({ x: 130, y: -140 })
                .animation({ curve: Curve.Ease, duration: 500 })
                .combine(TransitionEffect.rotate({ angle: -70 })),
              TransitionEffect.translate({ x: -150, y: -150 })
                .animation({ curve: Curve.EaseOut, duration: 350 })))
            .onClick(() => {
              this.showTirePressure = !this.showTirePressure
            })
        }
        if ((this.carInfo.tirePressure) && this.showTirePressure) {
          Text((this.carInfo.tirePressure![0] / 100).toFixed(1))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontSize('12vp')
            .position({ left: '27%', top: '45%' })
            .transition(TransitionEffect.OPACITY.animation({ curve: Curve.Ease, duration: 200 }))

          Text((this.carInfo.tirePressure![1] / 100).toFixed(1))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontSize('12vp')
            .position({ left: '55%', top: '11%' })
            .transition(TransitionEffect.OPACITY.animation({ curve: Curve.Ease, duration: 200 }))

          Text((this.carInfo.tirePressure![2] / 100).toFixed(1))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontSize('12vp')
            .position({ left: '57%', top: '84%' })
            .transition(TransitionEffect.OPACITY.animation({ curve: Curve.Ease, duration: 200 }))

          Text((this.carInfo.tirePressure![3] / 100).toFixed(1))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontSize('12vp')
            .position({ left: '86%', top: '50%' })
            .transition(TransitionEffect.OPACITY.animation({ curve: Curve.Ease, duration: 200 }))
        }
        Text(dayjs(this.carInfo.updateTime).format('HH:mm') || '-')
          .position({ top: '4vp', right: '8vp' })
          .fontSize('8vp')
          .opacity(0.2)
      }
      .width('60%')
      .height('100%')
      .position({ right: 0 })
    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      postCardAction(this, {
        action: 'router',
        abilityName: 'EntryAbility',
        params: {
          formId: this.formId
        }
      });
    })
  }

  private updateCarInfo() {
    postCardAction(this, {
      action: 'message',
      params: {}
    });
  }
}