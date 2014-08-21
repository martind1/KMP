unit Consts;

interface

resourcestring
  SAssignError = 'Cannot assign a %s to a %s';
  SFCreateError = 'Cannot create file %s';
  SFOpenError = 'Cannot open file %s';
  SReadError = 'Stream read error';
  SWriteError = 'Stream write error';
  SMemoryStreamError = 'Out of memory while expanding memory stream';
  SCantWriteResourceStreamError = 'Can''t write to a read-only resource stream';
  SDuplicateReference = 'WriteObject called twice for the same instance';
  SClassNotFound = 'Class %s not found';
  SInvalidImage = 'Invalid stream format';
  SResNotFound = 'Resource %s not found';
  SClassMismatch = 'Resource %s is of incorrect class';
  SListIndexError = 'List index out of bounds (%d)';
  SListCapacityError = 'List capacity out of bounds (%d)';
  SListCountError = 'List count out of bounds (%d)';
  SSortedListError = 'Operation not allowed on sorted string list';
  SDuplicateString = 'String list does not allow duplicates';
  SInvalidTabIndex = 'Tab index out of bounds';
  SDuplicateName = 'A component named %s already exists';
  SInvalidName = '''''%s'''' is not a valid component name';
  SDuplicateClass = 'A class named %s already exists';
  SNoComSupport = '%s has not been registered as a COM class';
  SInvalidInteger = '''''%s'''' is not a valid integer value';
  SLineTooLong = 'Line too long';
  SInvalidPropertyValue = 'Invalid property value';
  SInvalidPropertyPath = 'Invalid property path';
  SUnknownProperty = 'Property does not exist';
  SReadOnlyProperty = 'Property is read-only';
  SPropertyException = 'Error reading %s.%s: %s';
  SAncestorNotFound = 'Ancestor for ''%s'' not found';
  SInvalidBitmap = 'Bitmap image is not valid';
  SInvalidIcon = 'Icon image is not valid';
  SInvalidMetafile = 'Metafile is not valid';
  SInvalidPixelFormat = 'Invalid pixel format';
  SBitmapEmpty = 'Bitmap is empty';
  SScanLine = 'Scan line index out of range';
  SChangeIconSize = 'Cannot change the size of an icon';
  SOleGraphic = 'Invalid operation on TOleGraphic';
  SUnknownExtension = 'Unknown picture file extension (.%s)';
  SUnknownClipboardFormat = 'Unsupported clipboard format';
  SOutOfResources = 'Out of system resources';
  SNoCanvasHandle = 'Canvas does not allow drawing';
  SInvalidImageSize = 'Invalid image size';
  STooManyImages = 'Too many images';
  SDimsDoNotMatch = 'Image dimensions do not match image list dimensions';
  SInvalidImageList = 'Invalid ImageList';
  SReplaceImage = 'Unable to Replace Image';
  SImageIndexError = 'Invalid ImageList Index';
  SImageReadFail = 'Failed to read ImageList data from stream';
  SImageWriteFail = 'Failed to write ImageList data to stream';
  SWindowDCError = 'Error creating window device context';
  SClientNotSet = 'Client of TDrag not initialized';
  SWindowClass = 'Error creating window class';
  SWindowCreate = 'Error creating window';
  SCannotFocus = 'Cannot focus a disabled or invisible window';
  SParentRequired = 'Control ''%s'' has no parent window';
  SMDIChildNotVisible = 'Cannot hide an MDI Child Form';
  SVisibleChanged = 'Cannot change Visible in OnShow or OnHide';
  SCannotShowModal = 'Cannot make a visible window modal';
  SScrollBarRange = 'Scrollbar property out of range';
  SPropertyOutOfRange = '%s property out of range';
  SMenuIndexError = 'Menu index out of range';
  SMenuReinserted = 'Menu inserted twice';
  SMenuNotFound = 'Sub-menu is not in menu';
  SNoTimers = 'Not enough timers available';
  SNotPrinting = 'Printer is not currently printing';
  SPrinting = 'Printing in progress';
  SPrinterIndexError = 'Printer index out of range';
  SInvalidPrinter = 'Printer selected is not valid';
  SDeviceOnPort = '%s on %s';
  SGroupIndexTooLow = 'GroupIndex cannot be less than a previous menu item''s GroupIndex';
  STwoMDIForms = 'Cannot have more than one MDI form per application';
  SNoMDIForm = 'Cannot create form. No MDI forms are currently active';
  SRegisterError = 'Invalid component registration';
  SImageCanvasNeedsBitmap = 'Can only modify an image if it contains a bitmap';
  SControlParentSetToSelf = 'A control cannot have itself as its parent';
  SOKButton = 'OK';
  SCancelButton = 'Cancel';
  SYesButton = '&Yes';
  SNoButton = '&No';
  SHelpButton = '&Help';
  SCloseButton = '&Close';
  SIgnoreButton = '&Ignore';
  SRetryButton = '&Retry';
  SAbortButton = 'Abort';
  SAllButton = '&All';

  SCannotDragForm = 'Cannot drag a form';
  SPutObjectError = 'PutObject to undefined item';
  SCardDLLNotLoaded = 'Could not load CARDS.DLL';
  SDuplicateCardId = 'Duplicate CardId found';

  SDdeErr = 'An error returned from DDE  ($0%x)';
  SDdeConvErr = 'DDE Error - conversation not established ($0%x)';
  SDdeMemErr = 'Error occurred when DDE ran out of memory ($0%x)';
  SDdeNoConnect = 'Unable to connect DDE conversation';

  SFB = 'FB';
  SFG = 'FG';
  SBG = 'BG';
  SOldTShape = 'Cannot load older version of TShape';
  SVMetafiles = 'Metafiles';
  SVEnhMetafiles = 'Enhanced Metafiles';
  SVIcons = 'Icons';
  SVBitmaps = 'Bitmaps';
  SGridTooLarge = 'Grid too large for operation';
  STooManyDeleted = 'Too many rows or columns deleted';
  SIndexOutOfRange = 'Grid index out of range';
  SFixedColTooBig = 'Fixed column count must be less than column count';
  SFixedRowTooBig = 'Fixed row count must be less than row count';
  SInvalidStringGridOp = 'Cannot insert or delete rows from grid';
  SParseError = '%s on line %d';
  SIdentifierExpected = 'Identifier expected';
  SStringExpected = 'String expected';
  SNumberExpected = 'Number expected';
  SCharExpected = '''''%s'''' expected';
  SSymbolExpected = '%s expected';
  SInvalidNumber = 'Invalid numeric value';
  SInvalidString = 'Invalid string constant';
  SInvalidProperty = 'Invalid property value';
  SInvalidBinary = 'Invalid binary value';
  SOutlineIndexError = 'Outline index not found';
  SOutlineExpandError = 'Parent must be expanded';
  SInvalidCurrentItem = 'Invalid value for current item';
  SMaskErr = 'Invalid input value';
  SMaskEditErr = 'Invalid input value.  Use escape key to abandon changes';
  SOutlineError = 'Invalid outline index';
  SOutlineBadLevel = 'Incorrect level assignment';
  SOutlineSelection = 'Invalid selection';
  SOutlineFileLoad = 'File load error';
  SOutlineLongLine = 'Line too long';
  SOutlineMaxLevels = 'Maximum outline depth exceeded';

  SMsgDlgWarning = 'Warning';
  SMsgDlgError = 'Error';
  SMsgDlgInformation = 'Information';
  SMsgDlgConfirm = 'Confirm';
  SMsgDlgYes = '&Yes';
  SMsgDlgNo = '&No';
  SMsgDlgOK = 'OK';
  SMsgDlgCancel = 'Cancel';
  SMsgDlgHelp = '&Help';
  SMsgDlgHelpNone = 'No help available';
  SMsgDlgHelpHelp = 'Help';
  SMsgDlgAbort = '&Abort';
  SMsgDlgRetry = '&Retry';
  SMsgDlgIgnore = '&Ignore';
  SMsgDlgAll = '&All';
  SMsgDlgNoToAll = 'N&o to All';
  SMsgDlgYesToAll = 'Y&es to All';

  SmkcBkSp = 'BkSp';
  SmkcTab = 'Tab';
  SmkcEsc = 'Esc';
  SmkcEnter = 'Enter';
  SmkcSpace = 'Space';
  SmkcPgUp = 'PgUp';
  SmkcPgDn = 'PgDn';
  SmkcEnd = 'End';
  SmkcHome = 'Home';
  SmkcLeft = 'Left';
  SmkcUp = 'Up';
  SmkcRight = 'Right';
  SmkcDown = 'Down';
  SmkcIns = 'Ins';
  SmkcDel = 'Del';
  SmkcShift = 'Shift+';
  SmkcCtrl = 'Ctrl+';
  SmkcAlt = 'Alt+';

  srUnknown = '(Unknown)';
  srNone = '(None)';
  SOutOfRange = 'Value must be between %d and %d';
  SCannotCreateName = 'Cannot create a default method name for an unnamed component';

  SDateEncodeError = 'Invalid argument to date encode';
  STimeEncodeError = 'Invalid argument to time encode';
  SInvalidDate = '''''%s'''' is not a valid date';
  SInvalidTime = '''''%s'''' is not a valid time';
  SInvalidDateTime = '''''%s'''' is not a valid date and time';
  SInvalidFileName = 'Invalid file name - %s';
  SDefaultFilter = 'All files (*.*)|*.*';
  sAllFilter = 'All';
  SNoVolumeLabel = ': [ - no volume label - ]';
  SInsertLineError = 'Unable to insert a line';

  SConfirmCreateDir = 'The specified directory does not exist. Create it?';
  SSelectDirCap = 'Select Directory';
  SCannotCreateDir = 'Unable to create directory';
  SDirNameCap = 'Directory &Name:';
  SDrivesCap = 'D&rives:';
  SDirsCap = '&Directories:';
  SFilesCap = '&Files: (*.*)';
  SNetworkCap = 'Ne&twork...';

  SColorPrefix = 'Color';
  SColorTags = 'ABCDEFGHIJKLMNOP';

  SInvalidClipFmt = 'Invalid clipboard format';
  SIconToClipboard = 'Clipboard does not support Icons';

  SDefault = 'Default';

  SInvalidMemoSize = 'Text exceeds memo capacity';
  SCustomColors = 'Custom Colors';
  SInvalidPrinterOp = 'Operation not supported on selected printer';
  SNoDefaultPrinter = 'There is no default printer currently selected';

  SIniFileWriteError = 'Unable to write to %s';

  SBitsIndexError = 'Bits index out of range';

  SUntitled = '(Untitled)';

  SInvalidRegType = 'Invalid data type for ''%s''';
  SRegCreateFailed = 'Failed to create key %s';
  SRegSetDataFailed = 'Failed to set data for ''%s''';
  SRegGetDataFailed = 'Failed to get data for ''%s''';

  SUnknownConversion = 'Unknown RichEdit conversion file extension (.%s)';
  SDuplicateMenus = 'Menu ''%s'' is already being used by another form';

  SPictureLabel = 'Picture:';
  SPictureDesc = ' (%dx%d)';
  SPreviewLabel = 'Preview';

  SCannotOpenAVI = 'Cannot open AVI';

  SNotOpenErr = 'No MCI device open';
  SMPOpenFilter = 'All files (*.*)|*.*|Wave files (*.wav)|*.wav|Midi files (*.mid)|*.mid|Video for Windows (*.avi)|*.avi';
  SMCINil = '';
  SMCIAVIVideo = 'AVIVideo';
  SMCICDAudio = 'CDAudio';
  SMCIDAT = 'DAT';
  SMCIDigitalVideo = 'DigitalVideo';
  SMCIMMMovie = 'MMMovie';
  SMCIOther = 'Other';
  SMCIOverlay = 'Overlay';
  SMCIScanner = 'Scanner';
  SMCISequencer = 'Sequencer';
  SMCIVCR = 'VCR';
  SMCIVideodisc = 'Videodisc';
  SMCIWaveAudio = 'WaveAudio';
  SMCIUnknownError = 'Unknown error code';

  SBoldItalicFont = 'Bold Italic';
  SBoldFont = 'Bold';
  SItalicFont = 'Italic';
  SRegularFont = 'Regular';

implementation

end.