
@Preview
@Component
export default struct CarModel {
  @State trunk: boolean = false
  @State hood: boolean = false
  @State light: boolean = false
  @State skyWindow: boolean = false
  @State door: [boolean,boolean,boolean,boolean] = [false,false,false,false]
  @State window: [boolean,boolean,boolean,boolean] = [false,false,false,false]
  @State wheels: [boolean,boolean,boolean,boolean] = [false,false,false,false]

  build() {
    Stack() {
      Image($r('app.media.homepage_car'))
        .imgWidth()
      if (this.trunk) {
        Image($r('app.media.homepage_car_trunk'))
          .imgWidth()
      }
      if (this.hood) {
        Image($r('app.media.homepage_car_hood'))
          .imgWidth()
      }
      if (this.light) {
        Image($r('app.media.homepage_car_light'))
          .imgWidth()
      }
      if (this.skyWindow) {
        Image($r('app.media.homepage_car_skylight'))
          .imgWidth()
      }
      if (this.door[0]) {
        Image($r('app.media.homepage_car_driver_door'))
          .imgWidth()
      }
      if (this.window[0]) {
        Image($r('app.media.homepage_car_driver_window'))
          .imgWidth()
      }
      if (this.wheels[0]) {
        Image($r('app.media.homepage_car_driver_wheels'))
          .imgWidth()
          .position({left: '-8%'})
      }
      if (this.door[1]) {
        Image($r('app.media.homepage_car_side_door'))
          .imgWidth()
      }
      if (this.window[1]) {
        Image($r('app.media.homepage_car_side_window'))
          .imgWidth()
      }
      if (this.wheels[1]) {
        Image($r('app.media.homepage_car_side_wheels'))
          .imgWidth()
          .position({left: '-8%'})
      }
      if (this.door[2]) {
        Image($r('app.media.homepage_car_driver_rear_door'))
          .imgWidth()
      }
      if (this.window[2]) {
        Image($r('app.media.homepage_car_driver_rear_window'))
          .imgWidth()
      }
      if (this.wheels[2]) {
        Image($r('app.media.homepage_car_driver_rear_wheels'))
          .imgWidth()
      }
      if (this.door[3]) {
        Image($r('app.media.homepage_car_side_door2'))
          .imgWidth()
      }
      if (this.window[3]) {
        Image($r('app.media.homepage_car_side_window2'))
          .imgWidth()
      }
      if (this.wheels[3]) {
        Image($r('app.media.homepage_car_side_wheels2'))
          .imgWidth()
      }
    }
  }
  @Styles imgWidth() {
    .width('100%')
  }
}