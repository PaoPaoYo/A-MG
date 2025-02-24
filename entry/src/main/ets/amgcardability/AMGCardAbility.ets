import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import CardInfo from '../type/CardInfo';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { sendablePreferences } from '@kit.ArkData';
import getCarInfo from '../api/car';

export default class AMGCardAbility extends FormExtensionAbility {

  onAddForm(want: Want) {
    const formId = want.parameters![formInfo.FormParam.IDENTITY_KEY] as string;
    const formData: CardInfo = {
      formId,
      cardStatus: 0,
    };
    this.getCarInfo(formId)
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId: string, wantParams?: Record<string, Object>) {
    this.getCarInfo(formId)
  }

  onFormEvent(formId: string, message: string) {
    this.getCarInfo(formId)
  }

  onRemoveForm(formId: string) {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want: Want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }

  private getCarInfo(formId: string) {
    const obj: CardInfo = {
      cardStatus: 3
    }
    formProvider.updateForm(formId, formBindingData.createFormBindingData(obj))
    sendablePreferences.removePreferencesFromCacheSync(this.context, {
      name: 'carInfoStore'
    })
    sendablePreferences.getPreferences(this.context, {
      name: 'carInfoStore'
    }).then(db => {
      const token = db.getSync('token', '') as string
      hilog.fatal(0, '', 'FormAbGetStoreToken: ' + token)
      getCarInfo(token).then(res => {
        const obj: CardInfo = {
          cardStatus: 1,
          carInfo: res
        }
        formProvider.updateForm(formId, formBindingData.createFormBindingData(obj))
      }).catch((e: Error) => {
        const obj: CardInfo = {
          cardStatus: 2
        }
        formProvider.updateForm(formId, formBindingData.createFormBindingData(obj))
      })
    })
  }
}