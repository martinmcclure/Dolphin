"Filed out from Dolphin Smalltalk 7"!

DBRowBuffer subclass: #DBBoundBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants ODBCCTypes'
	classInstanceVariableNames: ''!
DBBoundBuffer guid: (GUID fromString: '{87b4c547-026e-11d3-9fd7-00a0cc3e4a32}')!
DBBoundBuffer comment: 'A DBBoundRow represnts a database row buffer that is directly bound to allocated memory for its columns. 

This is the normal type of buffer used by the Database Connection as it is more efficient when multiple rows are fetched.

'!
!DBBoundBuffer categoriesForClass!ODBC Interface! !
!DBBoundBuffer methodsFor!

bind: aDBStatement
	"Private - Bind the receiver's field buffers to columns in the result table."

	| hStmt |
	hStmt := super bind: aDBStatement.
	self contents with: columns
		do: 
			[:eachField :eachColumn | 
			aDBStatement dbCheckException: (ODBCLibrary default 
						sqlBindCol: hStmt
						columnNumber: eachColumn columnNumber
						targetType: eachColumn cType
						targetValuePtr: eachField fieldBuf
						bufferLength: (##(2 raisedTo: 16) min: eachField fieldSize)
						strLenOrInd: eachField lengthBuf)].
	^hStmt!

getData: aDBStatement
	"Private - Not currently relevant to a bound row, though it might be if
	we wanted to use SQLGetData for long values."! !
!DBBoundBuffer categoriesFor: #bind:!operations!private! !
!DBBoundBuffer categoriesFor: #getData:!data retrieval!private! !

