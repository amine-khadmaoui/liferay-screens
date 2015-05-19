/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/
import UIKit


@objc public protocol SignUpScreenletDelegate {

	optional func onSignUpResponse(
			screenlet: SignUpScreenlet,
			attributes: [String:AnyObject])

	optional func onSignUpError(
			screenlet: SignUpScreenlet,
			error: NSError)

}


@IBDesignable public class SignUpScreenlet: BaseScreenlet, AnonymousAuthType {

	//MARK: Inspectables

	@IBInspectable public var anonymousApiUserName: String? = "test@liferay.com"
	@IBInspectable public var anonymousApiPassword: String? = "test"

	@IBInspectable public var autoLogin: Bool = true

	@IBInspectable public var saveCredentials: Bool = true

	@IBInspectable public var companyId: Int64 = 0

	@IBOutlet public weak var delegate: SignUpScreenletDelegate?
	@IBOutlet public weak var autoLoginDelegate: LoginScreenletDelegate?


	public var viewModel: SignUpViewModel {
		return screenletView as! SignUpViewModel
	}


	//MARK: BaseScreenlet

	override internal func createInteractor(#name: String?, sender: AnyObject?) -> Interactor? {
		let interactor = SignUpInteractor(screenlet: self)

		interactor.onSuccess = {
			self.delegate?.onSignUpResponse?(self, attributes: interactor.resultUserAttributes!)

			if self.autoLogin {
				SessionContext.removeStoredSession()

				SessionContext.createSession(
						username: self.viewModel.emailAddress!,
						password: self.viewModel.password!,
						userAttributes: interactor.resultUserAttributes!)

				self.autoLoginDelegate?.onLoginResponse?(self,
						attributes: interactor.resultUserAttributes!)

				if self.saveCredentials {
					if SessionContext.storeSession() {
						self.autoLoginDelegate?.onCredentialsSaved?(self)
					}
				}
			}
		}

		interactor.onFailure = {
			self.delegate?.onSignUpError?(self, error: $0)
			return
		}

		return interactor
	}

}
