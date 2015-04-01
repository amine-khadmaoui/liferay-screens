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
import Foundation
import LRMobileSDK
import UICKeyChainStore


@objc public class SessionContext {

	//MARK: Singleton type

	private struct StaticInstance {
		static var currentSession:LRSession?
		static var userAttributes: [String:AnyObject] = [:]

		static var sessionStorage: SessionStorage = SessionStorageImpl()
	}

	//MARK: Public properties

	public class var hasSession: Bool {
		return StaticInstance.currentSession != nil
	}

	public class var currentUserName: String? {
		var authentication = StaticInstance.currentSession?.authentication
			as LRBasicAuthentication?

		return authentication?.username
	}

	public class var currentPassword: String? {
		var authentication = StaticInstance.currentSession?.authentication
			as LRBasicAuthentication?

		return authentication?.password
	}

	//MARK Public methods

	public class func userAttribute(key: String) -> AnyObject? {
		return StaticInstance.userAttributes[key]
	}

	public class func createSession(
			#username: String,
			password: String,
			userAttributes: [String:AnyObject])
			-> LRSession {

		let authentication = LRBasicAuthentication(
				username: username,
				password: password)

		return createSession(
				server: LiferayServerContext.server,
				authentication: authentication,
				userAttributes: userAttributes)
	}

	public class func createSessionFromCurrentSession() -> LRSession? {
		if let currentSessionValue = StaticInstance.currentSession {
			return LRSession(session: currentSessionValue)
		}

		return nil
	}

	public class func createBatchSessionFromCurrentSession() -> LRBatchSession? {
		if let currentSessionValue = StaticInstance.currentSession {
			return LRBatchSession(session: currentSessionValue)
		}

		return nil
	}

	public class func clearSession() {
		StaticInstance.currentSession = nil
		StaticInstance.userAttributes = [:]
	}

	public class func storeSession() -> Bool {
		return StaticInstance.sessionStorage.store(
				session: StaticInstance.currentSession,
				userAttributes: StaticInstance.userAttributes)
	}

	public class func removeStoredSession() -> Bool {
		return StaticInstance.sessionStorage.remove()
	}

	public class func loadSessionFromStore() -> Bool {
		if let result = StaticInstance.sessionStorage.load() {
			StaticInstance.currentSession = result.session
			StaticInstance.userAttributes = result.userAttributes

			return true
		}

		return false
	}

	private class func createSession(
			#server: String,
			authentication: LRAuthentication,
			userAttributes: [String:AnyObject])
			-> LRSession {

		let session = LRSession(server: server, authentication: authentication)

		StaticInstance.currentSession = session
		StaticInstance.userAttributes = userAttributes

		return session
	}

}