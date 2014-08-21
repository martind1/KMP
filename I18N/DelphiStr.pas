unit DelphiStr;

interface

type
  TStrDelphi = class(TObject)
  private
    HookResourceCount: integer;
    procedure HookResourceString(rs: PResStringRec);
    procedure Install;
    procedure TransToText(de, en, txt: string);
  public
    procedure Init;
  end;

  function StrDelphi: TStrDelphi;

implementation

uses
  Windows, SysUtils, consts, sysconst, bdeconst, comstrs, dbconsts, IniFiles, Classes,
  Forms,
  Err__Kmp, GNav_Kmp, Prots,
  TranFrm;

var fStrDelphi: TStrDelphi;

function StrDelphi: TStrDelphi;
begin
  if fStrDelphi = nil then
    fStrDelphi := TStrDelphi.Create;
  result := fStrDelphi;
end;

procedure TStrDelphi.HookResourceString(rs: PResStringRec);
var
  oldprotect: DWORD;
  N: DWORD;
  newStr: PChar;
  OldS, NewS: string;
begin
  OldS := Trim(LoadResString(rs));
  NewS := GNavigator.TranslateStr(self, Trim(OldS));
  {if OldS = NewS then
    Prot0('Neuer DelphiStr(%s)', [OldS]);}
  newStr := StrNew(PChar(NewS));
  //Prot0('HookResourceString(%d)->(%s)', [rs^.Identifier, newStr]);
  if not Windows.VirtualProtect(rs, SizeOf(rs^), PAGE_EXECUTE_READWRITE, @oldProtect) then
  begin
    N := GetLastError;
    EError('HookResourceString1:%d(%s)', [N, SysErrorMessage(N)]);
  end;
  rs^.Identifier := Integer(newStr);
  if not Windows.VirtualProtect(rs, SizeOf(rs^), oldProtect, @oldProtect) then
  begin
    N := GetLastError;
    EError('HookResourceString2:%d(%s)', [N, SysErrorMessage(N)]);
  end;
  Inc(HookResourceCount);
end;

{ TStrDelphi }

procedure TStrDelphi.Init;
//Standard-System-Resourcestrings umbiegen zu Übersetzungen
begin
  Install;
  if Sysparam.Sprache = '' then
    Exit;  //nix zu tun
  HookResourceCount := 0;
  ProtL('Translate Resourcestrings', [0]);
  //consts.pas
  HookResourceString(@SOpenFileTitle);
  {d2010
  HookResourceString(@SAssignError);
  HookResourceString(@SFCreateError);
  HookResourceString(@SFOpenError);
  HookResourceString(@SReadError);
  HookResourceString(@SWriteError);
  HookResourceString(@SMemoryStreamError);
  }
  HookResourceString(@SCantWriteResourceStreamError);
  HookResourceString(@SDuplicateReference);
  {d2010
  HookResourceString(@SClassNotFound);
  }
  HookResourceString(@SInvalidImage);
  {
  HookResourceString(@SResNotFound);
  }
  HookResourceString(@SClassMismatch);
  {
  HookResourceString(@SListIndexError);
  HookResourceString(@SListCapacityError);
  HookResourceString(@SListCountError);
  HookResourceString(@SSortedListError);
  HookResourceString(@SDuplicateString);
  }
  HookResourceString(@SInvalidTabIndex);
  HookResourceString(@SInvalidTabPosition);
  HookResourceString(@SInvalidTabStyle);
  {
  HookResourceString(@SDuplicateName);
  HookResourceString(@SInvalidName);
  HookResourceString(@SDuplicateClass);
  HookResourceString(@SNoComSupport);
  }
  HookResourceString(@SInvalidInteger);
  {
  HookResourceString(@SLineTooLong);
  HookResourceString(@SInvalidPropertyValue);
  HookResourceString(@SInvalidPropertyPath);
  HookResourceString(@SInvalidPropertyType);
  HookResourceString(@SInvalidPropertyElement);
  HookResourceString(@SUnknownProperty);
  HookResourceString(@SReadOnlyProperty);
  HookResourceString(@SPropertyException);
  HookResourceString(@SAncestorNotFound);
  }
  HookResourceString(@SInvalidBitmap);
  HookResourceString(@SInvalidIcon);
  HookResourceString(@SInvalidMetafile);
  HookResourceString(@SInvalidPixelFormat);
  HookResourceString(@SBitmapEmpty);
  HookResourceString(@SScanLine);
  HookResourceString(@SChangeIconSize);
  HookResourceString(@SOleGraphic);
  HookResourceString(@SUnknownExtension);
  HookResourceString(@SUnknownClipboardFormat);
  HookResourceString(@SOutOfResources);
  HookResourceString(@SNoCanvasHandle);
  HookResourceString(@SInvalidImageSize);
  HookResourceString(@STooManyImages);
  HookResourceString(@SDimsDoNotMatch);
  HookResourceString(@SInvalidImageList);
  HookResourceString(@SReplaceImage);
  HookResourceString(@SImageIndexError);
  HookResourceString(@SImageReadFail);
  HookResourceString(@SImageWriteFail);
  HookResourceString(@SWindowDCError);
  HookResourceString(@SClientNotSet);
  HookResourceString(@SWindowClass);
  HookResourceString(@SWindowCreate);
  HookResourceString(@SCannotFocus);
  HookResourceString(@SParentRequired);
  HookResourceString(@SMDIChildNotVisible);
  HookResourceString(@SVisibleChanged);
  HookResourceString(@SCannotShowModal);
  HookResourceString(@SScrollBarRange);
  HookResourceString(@SPropertyOutOfRange);
  HookResourceString(@SMenuIndexError);
  HookResourceString(@SMenuReinserted);
  HookResourceString(@SMenuNotFound);
  HookResourceString(@SNoTimers);
  HookResourceString(@SNotPrinting);
  HookResourceString(@SPrinting);
  HookResourceString(@SPrinterIndexError);
  HookResourceString(@SInvalidPrinter);
  HookResourceString(@SDeviceOnPort);
  HookResourceString(@SGroupIndexTooLow);
  HookResourceString(@STwoMDIForms);
  HookResourceString(@SNoMDIForm);
  {
  HookResourceString(@SRegisterError);
  }
  HookResourceString(@SImageCanvasNeedsBitmap);
  HookResourceString(@SControlParentSetToSelf);
  HookResourceString(@SOKButton);
  HookResourceString(@SCancelButton);
  HookResourceString(@SYesButton);
  HookResourceString(@SNoButton);
  HookResourceString(@SHelpButton);
  HookResourceString(@SCloseButton);
  HookResourceString(@SIgnoreButton);
  HookResourceString(@SRetryButton);
  HookResourceString(@SAbortButton);
  HookResourceString(@SAllButton);
  HookResourceString(@SCannotDragForm);
  HookResourceString(@SPutObjectError);
  HookResourceString(@SCardDLLNotLoaded);
  HookResourceString(@SDuplicateCardId);
  HookResourceString(@SDdeErr);
  HookResourceString(@SDdeConvErr);
  HookResourceString(@SDdeMemErr);
  HookResourceString(@SDdeNoConnect);
  HookResourceString(@SFB);
  HookResourceString(@SFG);
  HookResourceString(@SBG);
  HookResourceString(@SOldTShape);
  HookResourceString(@SVMetafiles);
  HookResourceString(@SVEnhMetafiles);
  HookResourceString(@SVIcons);
  HookResourceString(@SVBitmaps);
  HookResourceString(@SGridTooLarge);
  HookResourceString(@STooManyDeleted);
  HookResourceString(@SIndexOutOfRange);
  HookResourceString(@SFixedColTooBig);
  HookResourceString(@SFixedRowTooBig);
  HookResourceString(@SInvalidStringGridOp);
  {
  HookResourceString(@SParseError);
  HookResourceString(@SIdentifierExpected);
  HookResourceString(@SStringExpected);
  HookResourceString(@SNumberExpected);
  HookResourceString(@SCharExpected);
  HookResourceString(@SSymbolExpected);
  }
  HookResourceString(@SInvalidNumber);
  {
  HookResourceString(@SInvalidString);
  HookResourceString(@SInvalidProperty);
  HookResourceString(@SInvalidBinary);
  }
  HookResourceString(@SOutlineIndexError);
  HookResourceString(@SOutlineExpandError);
  HookResourceString(@SInvalidCurrentItem);
  HookResourceString(@SMaskErr);
  HookResourceString(@SMaskEditErr);
  HookResourceString(@SOutlineError);
  HookResourceString(@SOutlineBadLevel);
  HookResourceString(@SOutlineSelection);
  HookResourceString(@SOutlineFileLoad);
  HookResourceString(@SOutlineLongLine);
  HookResourceString(@SOutlineMaxLevels);
  HookResourceString(@SMsgDlgWarning);
  HookResourceString(@SMsgDlgError);
  HookResourceString(@SMsgDlgInformation);
  HookResourceString(@SMsgDlgConfirm);
  HookResourceString(@SMsgDlgYes);
  HookResourceString(@SMsgDlgNo);
  HookResourceString(@SMsgDlgOK);
  HookResourceString(@SMsgDlgCancel);
  HookResourceString(@SMsgDlgHelp);
  HookResourceString(@SMsgDlgHelpNone);
  HookResourceString(@SMsgDlgHelpHelp);
  HookResourceString(@SMsgDlgAbort);
  HookResourceString(@SMsgDlgRetry);
  HookResourceString(@SMsgDlgIgnore);
  HookResourceString(@SMsgDlgAll);
  HookResourceString(@SMsgDlgNoToAll);
  HookResourceString(@SMsgDlgYesToAll);
  HookResourceString(@SmkcBkSp);
  HookResourceString(@SmkcTab);
  HookResourceString(@SmkcEsc);
  HookResourceString(@SmkcEnter);
  HookResourceString(@SmkcSpace);
  HookResourceString(@SmkcPgUp);
  HookResourceString(@SmkcPgDn);
  HookResourceString(@SmkcEnd);
  HookResourceString(@SmkcHome);
  HookResourceString(@SmkcLeft);
  HookResourceString(@SmkcUp);
  HookResourceString(@SmkcRight);
  HookResourceString(@SmkcDown);
  HookResourceString(@SmkcIns);
  HookResourceString(@SmkcDel);
  HookResourceString(@SmkcShift);
  HookResourceString(@SmkcCtrl);
  HookResourceString(@SmkcAlt);
  HookResourceString(@srUnknown);
  HookResourceString(@srNone);
  HookResourceString(@SOutOfRange);
  {
  HookResourceString(@SCannotCreateName);
  }
  HookResourceString(@SDateEncodeError);
  HookResourceString(@STimeEncodeError);
  HookResourceString(@SInvalidDate);
  HookResourceString(@SInvalidTime);
  HookResourceString(@SInvalidDateTime);
  HookResourceString(@SInvalidFileName);
  HookResourceString(@SDefaultFilter);
  HookResourceString(@sAllFilter);
  HookResourceString(@SNoVolumeLabel);
  HookResourceString(@SInsertLineError);
  HookResourceString(@SConfirmCreateDir);
  HookResourceString(@SSelectDirCap);
  HookResourceString(@SCannotCreateDir);
  HookResourceString(@SDirNameCap);
  HookResourceString(@SDrivesCap);
  HookResourceString(@SDirsCap);
  HookResourceString(@SFilesCap);
  HookResourceString(@SNetworkCap);
  HookResourceString(@SColorPrefix);
  HookResourceString(@SColorTags);
  HookResourceString(@SInvalidClipFmt);
  HookResourceString(@SIconToClipboard);
  HookResourceString(@SCannotOpenClipboard);
  HookResourceString(@SDefault);
  HookResourceString(@SInvalidMemoSize);
  HookResourceString(@SCustomColors);
  HookResourceString(@SInvalidPrinterOp);
  HookResourceString(@SNoDefaultPrinter);
  HookResourceString(@SIniFileWriteError);
  HookResourceString(@SBitsIndexError);
  HookResourceString(@SUntitled);
  HookResourceString(@SInvalidRegType);
  {
  HookResourceString(@SRegCreateFailed);
  HookResourceString(@SRegSetDataFailed);
  HookResourceString(@SRegGetDataFailed);
  }
  HookResourceString(@SUnknownConversion);
  HookResourceString(@SDuplicateMenus);
  HookResourceString(@SPictureLabel);
  HookResourceString(@SPictureDesc);
  HookResourceString(@SPreviewLabel);
  HookResourceString(@SCannotOpenAVI);
  HookResourceString(@SNotOpenErr);
  HookResourceString(@SMPOpenFilter);
  HookResourceString(@SMCINil);
  HookResourceString(@SMCIAVIVideo);
  HookResourceString(@SMCICDAudio);
  HookResourceString(@SMCIDAT);
  HookResourceString(@SMCIDigitalVideo);
  HookResourceString(@SMCIMMMovie);
  HookResourceString(@SMCIOther);
  HookResourceString(@SMCIOverlay);
  HookResourceString(@SMCIScanner);
  HookResourceString(@SMCISequencer);
  HookResourceString(@SMCIVCR);
  HookResourceString(@SMCIVideodisc);
  HookResourceString(@SMCIWaveAudio);
  HookResourceString(@SMCIUnknownError);
  HookResourceString(@SBoldItalicFont);
  HookResourceString(@SBoldFont);
  HookResourceString(@SItalicFont);
  HookResourceString(@SRegularFont);
  HookResourceString(@SPropertiesVerb);
  {
  HookResourceString(@sWindowsSocketError);
  HookResourceString(@sAsyncSocketError);
  HookResourceString(@sNoAddress);
  HookResourceString(@sCannotListenOnOpen);
  HookResourceString(@sCannotCreateSocket);
  HookResourceString(@sSocketAlreadyOpen);
  HookResourceString(@sCantChangeWhileActive);
  HookResourceString(@sSocketMustBeBlocking);
  HookResourceString(@sSocketIOError);
  HookResourceString(@sSocketRead);
  HookResourceString(@sSocketWrite);
  }
  HookResourceString(@SServiceFailed);
  HookResourceString(@SExecute);
  HookResourceString(@SStart);
  HookResourceString(@SStop);
  HookResourceString(@SPause);
  HookResourceString(@SContinue);
  HookResourceString(@SInterrogate);
  HookResourceString(@SShutdown);
  HookResourceString(@SCustomError);
  HookResourceString(@SServiceInstallOK);
  HookResourceString(@SServiceInstallFailed);
  HookResourceString(@SServiceUninstallOK);
  HookResourceString(@SServiceUninstallFailed);
  HookResourceString(@SInvalidActionRegistration);
  HookResourceString(@SInvalidActionUnregistration);
  HookResourceString(@SInvalidActionEnumeration);
  HookResourceString(@SInvalidActionCreation);
  HookResourceString(@SDockedCtlNeedsName);
  HookResourceString(@SDockTreeRemoveError);
  HookResourceString(@SDockZoneNotFound);
  HookResourceString(@SDockZoneHasNoCtl);
  HookResourceString(@SAllCommands);
  HookResourceString(@SDuplicateItem);
  {
  HookResourceString(@SDuplicatePropertyCategory);
  HookResourceString(@SUnknownPropertyCategory);
  HookResourceString(@SActionCategoryName);
  HookResourceString(@SActionCategoryDesc);
  HookResourceString(@SDataCategoryName);
  HookResourceString(@SDataCategoryDesc);
  HookResourceString(@SDatabaseCategoryName);
  HookResourceString(@SDatabaseCategoryDesc);
  HookResourceString(@SDragNDropCategoryName);
  HookResourceString(@SDragNDropCategoryDesc);
  HookResourceString(@SHelpCategoryName);
  HookResourceString(@SHelpCategoryDesc);
  HookResourceString(@SLayoutCategoryName);
  HookResourceString(@SLayoutCategoryDesc);
  HookResourceString(@SLegacyCategoryName);
  HookResourceString(@SLegacyCategoryDesc);
  HookResourceString(@SLinkageCategoryName);
  HookResourceString(@SLinkageCategoryDesc);
  HookResourceString(@SLocaleCategoryName);
  HookResourceString(@SLocaleCategoryDesc);
  HookResourceString(@SLocalizableCategoryName);
  HookResourceString(@SLocalizableCategoryDesc);
  HookResourceString(@SMiscellaneousCategoryName);
  HookResourceString(@SMiscellaneousCategoryDesc);
  HookResourceString(@SVisualCategoryName);
  HookResourceString(@SVisualCategoryDesc);
  HookResourceString(@SInputCategoryName);
  HookResourceString(@SInputCategoryDesc);
  HookResourceString(@SInvalidMask);
  HookResourceString(@SInvalidFilter);
  HookResourceString(@SInvalidCategory);
  HookResourceString(@sOperationNotAllowed);
  }
  //sysconsts.pas
  HookResourceString(@SUnknown);
  //HookResourceString(@SInvalidInteger);  bereits oben
  HookResourceString(@SInvalidFloat);
  //HookResourceString(@SInvalidDate);  bereits oben
  //HookResourceString(@SInvalidTime);  bereits oben
  //HookResourceString(@SInvalidDateTime);  bereits oben
  //HookResourceString(@STimeEncodeError);  bereits oben
  //HookResourceString(@SDateEncodeError);  bereits oben
  HookResourceString(@SOutOfMemory);
  HookResourceString(@SInOutError);
  HookResourceString(@SFileNotFound);
  HookResourceString(@SInvalidFilename);
  HookResourceString(@STooManyOpenFiles);
  HookResourceString(@SAccessDenied);
  HookResourceString(@SEndOfFile);
  HookResourceString(@SDiskFull);
  HookResourceString(@SInvalidInput);
  HookResourceString(@SDivByZero);
  HookResourceString(@SRangeError);
  HookResourceString(@SIntOverflow);
  HookResourceString(@SInvalidOp);
  HookResourceString(@SZeroDivide);
  HookResourceString(@SOverflow);
  HookResourceString(@SUnderflow);
  HookResourceString(@SInvalidPointer);
  HookResourceString(@SInvalidCast);
  {
  HookResourceString(@SAccessViolation);
  }
  HookResourceString(@SStackOverflow);
  HookResourceString(@SControlC);
  HookResourceString(@SPrivilege);
  HookResourceString(@SOperationAborted);
  HookResourceString(@SException);
  HookResourceString(@SExceptTitle);
  HookResourceString(@SInvalidFormat);
  HookResourceString(@SArgumentMissing);
  HookResourceString(@SInvalidVarCast);
  HookResourceString(@SInvalidVarOp);
  HookResourceString(@SDispatchError);
  HookResourceString(@SReadAccess);
  HookResourceString(@SWriteAccess);
  HookResourceString(@SResultTooLong);
  HookResourceString(@SFormatTooLong);
  HookResourceString(@SVarArrayCreate);
  HookResourceString(@SVarNotArray);
  HookResourceString(@SVarArrayBounds);
  HookResourceString(@SExternalException);
  HookResourceString(@SAssertionFailed);
  HookResourceString(@SIntfCastError);
  HookResourceString(@SSafecallException);
  HookResourceString(@SAssertError);
  HookResourceString(@SAbstractError);
  HookResourceString(@SModuleAccessViolation);
  HookResourceString(@SCannotReadPackageInfo);
  HookResourceString(@sErrorLoadingPackage);
  HookResourceString(@SInvalidPackageFile);
  HookResourceString(@SInvalidPackageHandle);
  HookResourceString(@SDuplicatePackageUnit);
  HookResourceString(@SWin32Error);
  HookResourceString(@SUnkWin32Error);
  HookResourceString(@SNL);
  HookResourceString(@SShortMonthNameJan);
  HookResourceString(@SShortMonthNameFeb);
  HookResourceString(@SShortMonthNameMar);
  HookResourceString(@SShortMonthNameApr);
  HookResourceString(@SShortMonthNameMay);
  HookResourceString(@SShortMonthNameJun);
  HookResourceString(@SShortMonthNameJul);
  HookResourceString(@SShortMonthNameAug);
  HookResourceString(@SShortMonthNameSep);
  HookResourceString(@SShortMonthNameOct);
  HookResourceString(@SShortMonthNameNov);
  HookResourceString(@SShortMonthNameDec);
  HookResourceString(@SLongMonthNameJan);
  HookResourceString(@SLongMonthNameFeb);
  HookResourceString(@SLongMonthNameMar);
  HookResourceString(@SLongMonthNameApr);
  HookResourceString(@SLongMonthNameMay);
  HookResourceString(@SLongMonthNameJun);
  HookResourceString(@SLongMonthNameJul);
  HookResourceString(@SLongMonthNameAug);
  HookResourceString(@SLongMonthNameSep);
  HookResourceString(@SLongMonthNameOct);
  HookResourceString(@SLongMonthNameNov);
  HookResourceString(@SLongMonthNameDec);
  HookResourceString(@SShortDayNameSun);
  HookResourceString(@SShortDayNameMon);
  HookResourceString(@SShortDayNameTue);
  HookResourceString(@SShortDayNameWed);
  HookResourceString(@SShortDayNameThu);
  HookResourceString(@SShortDayNameFri);
  HookResourceString(@SShortDayNameSat);
  HookResourceString(@SLongDayNameSun);
  HookResourceString(@SLongDayNameMon);
  HookResourceString(@SLongDayNameTue);
  HookResourceString(@SLongDayNameWed);
  HookResourceString(@SLongDayNameThu);
  HookResourceString(@SLongDayNameFri);
  HookResourceString(@SLongDayNameSat);
  //bdeconst
  HookResourceString(@SAutoSessionExclusive);
  HookResourceString(@SAutoSessionExists);
  HookResourceString(@SAutoSessionActive);
  HookResourceString(@SDuplicateDatabaseName);
  HookResourceString(@SDuplicateSessionName);
  HookResourceString(@SInvalidSessionName);
  HookResourceString(@SDatabaseNameMissing);
  HookResourceString(@SSessionNameMissing);
  HookResourceString(@SDatabaseOpen);
  HookResourceString(@SDatabaseClosed);
  HookResourceString(@SDatabaseHandleSet);
  HookResourceString(@SSessionActive);
  HookResourceString(@SHandleError);
  HookResourceString(@SInvalidFloatField);
  HookResourceString(@SInvalidIntegerField);
  HookResourceString(@STableMismatch);
  HookResourceString(@SFieldAssignError);
  HookResourceString(@SNoReferenceTableName);
  HookResourceString(@SCompositeIndexError);
  HookResourceString(@SInvalidBatchMove);
  HookResourceString(@SEmptySQLStatement);
  HookResourceString(@SNoParameterValue);
  HookResourceString(@SNoParameterType);
  HookResourceString(@SLoginError);
  HookResourceString(@SInitError);
  HookResourceString(@SDatabaseEditor);
  HookResourceString(@SExplore);
  HookResourceString(@SLinkDetail);
  HookResourceString(@SLinkMasterSource);
  HookResourceString(@SLinkMaster);
  HookResourceString(@SGQEVerb);
  HookResourceString(@SBindVerb);
  HookResourceString(@SIDAPILangID);
  HookResourceString(@SDisconnectDatabase);
  HookResourceString(@SBDEError);
  HookResourceString(@SLookupSourceError);
  HookResourceString(@SLookupTableError);
  HookResourceString(@SLookupIndexError);
  HookResourceString(@SParameterTypes);
  HookResourceString(@SInvalidParamFieldType);
  HookResourceString(@STruncationError);
  HookResourceString(@SDataTypes);
  HookResourceString(@SResultName);
  HookResourceString(@SDBCaption);
  HookResourceString(@SParamEditor);
  HookResourceString(@SIndexFilesEditor);
  HookResourceString(@SNoIndexFiles);
  HookResourceString(@SIndexDoesNotExist);
  HookResourceString(@SNoTableName);
  HookResourceString(@SNoDataSetField);
  HookResourceString(@SBatchExecute);
  HookResourceString(@SNoCachedUpdates);
  HookResourceString(@SInvalidAliasName);
  HookResourceString(@SNoFieldAccess);
  HookResourceString(@SUpdateSQLEditor);
  HookResourceString(@SNoDataSet);
  //HookResourceString(@SUntitled);  bereits oben
  HookResourceString(@SUpdateWrongDB);
  HookResourceString(@SUpdateFailed);
  HookResourceString(@SSQLGenSelect);
  HookResourceString(@SSQLNotGenerated);
  HookResourceString(@SSQLDataSetOpen);
  HookResourceString(@SLocalTransDirty);
  HookResourceString(@SMissingDataSet);
  HookResourceString(@SNoProvider);
  HookResourceString(@SNotAQuery);
  //ComStrs
  HookResourceString(@sTabFailClear);
  HookResourceString(@sTabFailDelete);
  HookResourceString(@sTabFailRetrieve);
  HookResourceString(@sTabFailGetObject);
  HookResourceString(@sTabFailSet);
  HookResourceString(@sTabFailSetObject);
  HookResourceString(@sTabMustBeMultiLine);
  HookResourceString(@sInvalidLevel);
  HookResourceString(@sInvalidLevelEx);
  HookResourceString(@sInvalidIndex);
  HookResourceString(@sInsertError);
  HookResourceString(@sInvalidOwner);
  HookResourceString(@sUnableToCreateColumn);
  HookResourceString(@sUnableToCreateItem);
  HookResourceString(@sRichEditInsertError);
  HookResourceString(@sRichEditLoadFail);
  HookResourceString(@sRichEditSaveFail);
  HookResourceString(@sTooManyPanels);
  HookResourceString(@sHKError);
  HookResourceString(@sHKInvalid);
  HookResourceString(@sHKInvalidWindow);
  HookResourceString(@sHKAssigned);
  HookResourceString(@sUDAssociated);
  HookResourceString(@sPageIndexError);
  HookResourceString(@sInvalidComCtl32);
  HookResourceString(@sDateTimeMax);
  HookResourceString(@sDateTimeMin);
  HookResourceString(@sNeedAllowNone);
  HookResourceString(@sFailSetCalDateTime);
  HookResourceString(@sFailSetCalMaxSelRange);
  HookResourceString(@sFailSetCalMinMaxRange);
  HookResourceString(@sCalRangeNeedsMultiSelect);
  HookResourceString(@sFailsetCalSelRange);
  //DbConsts
  HookResourceString(@SInvalidFieldSize);
  HookResourceString(@SInvalidFieldKind);
  HookResourceString(@SInvalidFieldRegistration);
  HookResourceString(@SUnknownFieldType);
  HookResourceString(@SFieldNameMissing);
  HookResourceString(@SDuplicateFieldName);
  HookResourceString(@SFieldNotFound);
  HookResourceString(@SFieldAccessError);
  HookResourceString(@SFieldValueError);
  HookResourceString(@SFieldRangeError);
  HookResourceString(@SInvalidIntegerValue);
  HookResourceString(@SInvalidBoolValue);
  HookResourceString(@SInvalidFloatValue);
  HookResourceString(@SFieldTypeMismatch);
  HookResourceString(@SFieldSizeMismatch);
  HookResourceString(@SInvalidVarByteArray);
  HookResourceString(@SFieldOutOfRange);
  HookResourceString(@SBCDOverflow);
  HookResourceString(@SFieldRequired);
  HookResourceString(@SDataSetMissing);
  HookResourceString(@SInvalidCalcType);
  HookResourceString(@SFieldReadOnly);
  HookResourceString(@SFieldIndexError);
  HookResourceString(@SNoFieldIndexes);
  HookResourceString(@SNotIndexField);
  HookResourceString(@SIndexFieldMissing);
  HookResourceString(@SDuplicateIndexName);
  HookResourceString(@SNoIndexForFields);
  HookResourceString(@SIndexNotFound);
  {D2010
  HookResourceString(@SDuplicateName);
  }
  HookResourceString(@SCircularDataLink);
  HookResourceString(@SLookupInfoError);
  HookResourceString(@SDataSourceChange);
  HookResourceString(@SNoNestedMasterSource);
  HookResourceString(@SDataSetOpen);
  HookResourceString(@SNotEditing);
  HookResourceString(@SDataSetClosed);
  HookResourceString(@SDataSetEmpty);
  HookResourceString(@SDataSetReadOnly);
  HookResourceString(@SNestedDataSetClass);
  HookResourceString(@SExprTermination);
  HookResourceString(@SExprNameError);
  HookResourceString(@SExprStringError);
  HookResourceString(@SExprInvalidChar);
  HookResourceString(@SExprNoLParen);
  HookResourceString(@SExprNoRParen);
  HookResourceString(@SExprNoRParenOrComma);
  HookResourceString(@SExprExpected);
  HookResourceString(@SExprBadField);
  HookResourceString(@SExprBadNullTest);
  HookResourceString(@SExprRangeError);
  HookResourceString(@SExprNotBoolean);
  HookResourceString(@SExprIncorrect);
  HookResourceString(@SExprNothing);
  HookResourceString(@SExprTypeMis);
  HookResourceString(@SExprBadScope);
  HookResourceString(@SExprNoArith);
  HookResourceString(@SExprNotAgg);
  HookResourceString(@SExprBadConst);
  HookResourceString(@SExprNoAggFilter);
  HookResourceString(@SExprEmptyInList);
  HookResourceString(@SInvalidKeywordUse);
  HookResourceString(@STextFalse);
  HookResourceString(@STextTrue);
  HookResourceString(@SParameterNotFound);
  HookResourceString(@SInvalidVersion);
  HookResourceString(@SParamTooBig);
  HookResourceString(@SBadFieldType);
  HookResourceString(@SAggActive);
  HookResourceString(@SProviderSQLNotSupported);
  HookResourceString(@SProviderExecuteNotSupported);
  HookResourceString(@SExprNoAggOnCalcs);
  HookResourceString(@SRecordChanged);
  {
  HookResourceString(@SFirstRecord);
  HookResourceString(@SPriorRecord);
  HookResourceString(@SNextRecord);
  HookResourceString(@SLastRecord);
  HookResourceString(@SInsertRecord);
  HookResourceString(@SDeleteRecord);
  HookResourceString(@SEditRecord);
  HookResourceString(@SPostEdit);
  HookResourceString(@SCancelEdit);
  HookResourceString(@SRefreshRecord);
  }
  HookResourceString(@SDeleteRecordQuestion);
  HookResourceString(@SDeleteMultipleRecordsQuestion);
  HookResourceString(@SRecordNotFound);
  {
  HookResourceString(@SDataSourceFixed);
  HookResourceString(@SNotReplicatable);
  HookResourceString(@SPropDefByLookup);
  }
  HookResourceString(@STooManyColumns);
  {
  HookResourceString(@SRemoteLogin);
  HookResourceString(@SDataBindings);
  }
  //es fehlen noch: (suche nach 'resourcestring' im VCL Quelltext)
  //oleconst,
  //schtconst,
  //webconst
  Prot0('%d OK', [HookResourceCount]);
  SMess0;
end;

procedure TStrDelphi.Install;
var
  aIniFile: TIniFile;
  L, F: TStringList;
  I: integer;
begin
  //HookResourceString Aufrufe erzeugen:
  {L := TStringList.Create;
  F := TStringList.Create;
  //aIniFile := TIniFile.Create('C:\Delphi\LAWA\I18N\Consts_de.ini');
  //aIniFile := TIniFile.Create('C:\Delphi\LAWA\I18N\sysconst_de.ini');
  //aIniFile := TIniFile.Create('C:\Delphi\LAWA\I18N\bdeconst_de.ini');
  //aIniFile := TIniFile.Create('C:\Delphi\LAWA\I18N\comstrs_de.ini');
  //aIniFile := TIniFile.Create('C:\Delphi\LAWA\I18N\dbconsts_de.ini');
  aIniFile.ReadSection('Strings', L);
  for I := 0 to L.Count - 1 do
    F.Add(Format('HookResourceString(@%s);', [L[I]]));
  //F.SaveToFile('C:\Delphi\LAWA\I18N\Consts_de.pas');
  //F.SaveToFile('C:\Delphi\LAWA\I18N\sysconst_de.pas');
  //F.SaveToFile('C:\Delphi\LAWA\I18N\bdeconst_de.pas');
  //F.SaveToFile('C:\Delphi\LAWA\I18N\comstrs_de.pas');
  //F.SaveToFile('C:\Delphi\LAWA\I18N\dbconsts_de.pas');
  L.Free;
  F.Free;}

  //de=en Umsetzungstabellen als Textfiles generieren
  {TransToText('C:\Delphi\LAWA\I18N\BdeConst_de.ini', 'C:\Delphi\LAWA\I18N\BdeConst_en.ini',
    'C:\Delphi\LAWA\I18N\BdeConst_de_en.txt');
  TransToText('C:\Delphi\LAWA\I18N\ComStrs_de.ini', 'C:\Delphi\LAWA\I18N\ComStrs_en.ini',
    'C:\Delphi\LAWA\I18N\ComStrs_de_en.txt');
  TransToText('C:\Delphi\LAWA\I18N\Consts_de.ini', 'C:\Delphi\LAWA\I18N\Consts_en.ini',
    'C:\Delphi\LAWA\I18N\Consts_de_en.txt');
  TransToText('C:\Delphi\LAWA\I18N\DbConsts_de.ini', 'C:\Delphi\LAWA\I18N\DbConsts_en.ini',
    'C:\Delphi\LAWA\I18N\DbConsts_de_en.txt');
  TransToText('C:\Delphi\LAWA\I18N\SysConst_de.ini', 'C:\Delphi\LAWA\I18N\SysConst_en.ini',
    'C:\Delphi\LAWA\I18N\SysConst_de_en.txt');}
  {MD 11.09.07
  TransToText('d:\Delphi\LAWA\I18N\ini\Consts_de.ini', 'd:\Delphi\LAWA\I18N\ini\Consts_en.ini',
    'd:\Delphi\LAWA\I18N\Consts_de_en.txt');} 

  //In Datenbanbk speichern:
  {GNavigator.StartForm(Application, 'TRAN');
  FrmTran.ImportTextfile('C:\Delphi\LAWA\I18N\BdeConst_de_en.txt;en;System');
  FrmTran.ImportTextfile('C:\Delphi\LAWA\I18N\ComStrs_de_en.txt;en;System');
  FrmTran.ImportTextfile('C:\Delphi\LAWA\I18N\Consts_de_en.txt;en;System');
  FrmTran.ImportTextfile('C:\Delphi\LAWA\I18N\DbConsts_de_en.txt;en;System');
  FrmTran.ImportTextfile('C:\Delphi\LAWA\I18N\SysConst_de_en.txt;en;System');
  FrmTran.Close;}
  { en-us Datenbanbk speichern: - MD 11.09.07
  GNavigator.StartForm(Application, 'TRAN');
  FrmTran.ImportTextfile('C:\Delphi\LAWA\I18N\BdeConst_de_en.txt;en-us;System');
  FrmTran.ImportTextfile('C:\Delphi\LAWA\I18N\ComStrs_de_en.txt;en-us;System');
  FrmTran.ImportTextfile('C:\Delphi\LAWA\I18N\Consts_de_en.txt;en-us;System');
  FrmTran.ImportTextfile('C:\Delphi\LAWA\I18N\DbConsts_de_en.txt;en-us;System');
  FrmTran.ImportTextfile('C:\Delphi\LAWA\I18N\SysConst_de_en.txt;en-us;System');
  FrmTran.Close; }
end;

procedure TStrDelphi.TransToText(de, en, txt: string);
var
  Ini_de, Ini_en: TIniFile;
  L, F: TStringList;
  I: integer;
  S1, S2: string;
  function strip(S: string): string;
  var
    P: integer;
  begin
    P := Pos('//', S);
    if P > 0 then
      S := Trim(copy(S, 1, P-1));
    result := Trim(copy(S, 2, length(S) - 3));   //'' am Beginn und Ende weg

    result := StringReplace(result, '''''', '''', [rfReplaceAll, rfIgnoreCase]);
  end;

begin
  L := TStringList.Create;
  F := TStringList.Create;
  Ini_de := TIniFile.Create(de);
  Ini_en := TIniFile.Create(en);
  Ini_de.ReadSection('Strings', L);

  for I := 0 to L.Count - 1 do
  begin
    S1 := Strip(Ini_de.ReadString('Strings', L[I], ''));
    S2 := Strip(Ini_en.ReadString('Strings', L[I], ''));
    if S1 = '' then
      continue;
    if S2 = '' then
      S2 := copy(L[I], 2, MaxInt);  //SDuplicateItem -> DuplicateItem
    F.Add(Format('%s=%s', [S1, S2]));
  end;
  F.SaveToFile(txt);

  Ini_de.Free;
  Ini_en.Free;
  L.Free;
  F.Free;
end;

end.
