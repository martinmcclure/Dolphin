"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_QOS_SETTING_INFO
	instanceVariableNames: 'setting'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_QOS_SETTING_INFO guid: (GUID fromString: '{a0bcefe3-d299-4e8a-9c7a-6e753a441ad6}')!
HTTP_QOS_SETTING_INFO comment: '<HTTP_QOS_SETTING_INFO> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_QOS_SETTING_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Contains information about a QOS setting."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(a0bcefe3-d299-4e8a-9c7a-6e753a441ad6), helpstring("Contains information about a QOS setting.")]
struct tagHTTP_QOS_SETTING_INFO {
	HTTP_QOS_SETTING_TYPE QosType;
	void* QosSetting;
} HTTP_QOS_SETTING_INFO;
'!
!HTTP_QOS_SETTING_INFO categoriesForClass!WinHttpServer-Structs! !
!HTTP_QOS_SETTING_INFO methodsFor!

printFields: aCollection on: aStream limit: anInteger
	self value ifNotNil: [:val | val printFieldsOn: aStream limit: anInteger]!

propertyId
	^self class propertyId!

QosSetting
	"Answer the <ExternalAddress> value of the receiver's 'QosSetting' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #QosSetting)) asExternalAddress!

QosSetting: anExternalAddress
	"Set the receiver's 'QosSetting' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: ##(self offsetOf: #QosSetting) put: anExternalAddress!

QosType
	"Answer the <Integer> value of the receiver's 'QosType' field."

	^bytes sdwordAtOffset: 0!

QosType: anInteger
	"Set the receiver's 'QosType' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: 0 put: anInteger!

value
	^setting
		ifNil: 
			[setting := (##(Array
						with: HTTP_BANDWIDTH_LIMIT_INFO
						with: HTTP_CONNECTION_LIMIT_INFO
						with: HTTP_FLOWRATE_INFO) at: self QosType + 1)
						fromAddress: self QosSetting]!

value: aHttpQosPropertyInfo
	setting := aHttpQosPropertyInfo.
	self
		QosType: aHttpQosPropertyInfo qosType;
		QosSetting: aHttpQosPropertyInfo yourAddress! !
!HTTP_QOS_SETTING_INFO categoriesFor: #printFields:on:limit:!development!printing!private! !
!HTTP_QOS_SETTING_INFO categoriesFor: #propertyId!constants!public! !
!HTTP_QOS_SETTING_INFO categoriesFor: #QosSetting!**compiled accessors**!public! !
!HTTP_QOS_SETTING_INFO categoriesFor: #QosSetting:!**compiled accessors**!public! !
!HTTP_QOS_SETTING_INFO categoriesFor: #QosType!**compiled accessors**!public! !
!HTTP_QOS_SETTING_INFO categoriesFor: #QosType:!**compiled accessors**!public! !
!HTTP_QOS_SETTING_INFO categoriesFor: #value!accessing!public! !
!HTTP_QOS_SETTING_INFO categoriesFor: #value:!accessing!public! !

!HTTP_QOS_SETTING_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_QOS_SETTING_INFO structure.

	HTTP_QOS_SETTING_INFO compileDefinition

		typedef [uuid(a0bcefe3-d299-4e8a-9c7a-6e753a441ad6), helpstring('Contains information about a QOS setting.')]
		struct tagHTTP_QOS_SETTING_INFO {
			HTTP_QOS_SETTING_TYPE QosType;
			void* QosSetting;
		} HTTP_QOS_SETTING_INFO;
"

	self
		defineField: #QosType type: SDWORDField new offset: 0;
		defineField: #QosSetting type: LPVOIDField new offset: 4.
	self byteSize: 8!

maxBandwidth: anInteger
	^self qosSetting: (HTTP_BANDWIDTH_LIMIT_INFO maxBandwidth: anInteger)!

maxConnections: anInteger
	^self qosSetting: (HTTP_CONNECTION_LIMIT_INFO maxConnections: anInteger)!

propertyId
	^HttpServerQosProperty!

qosSetting: anHttpQosSetting
	^(self new)
		value: anHttpQosSetting;
		yourself! !
!HTTP_QOS_SETTING_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!HTTP_QOS_SETTING_INFO class categoriesFor: #maxBandwidth:!instance creation!public! !
!HTTP_QOS_SETTING_INFO class categoriesFor: #maxConnections:!instance creation!public! !
!HTTP_QOS_SETTING_INFO class categoriesFor: #propertyId!constants!public! !
!HTTP_QOS_SETTING_INFO class categoriesFor: #qosSetting:!instance creation!public! !

