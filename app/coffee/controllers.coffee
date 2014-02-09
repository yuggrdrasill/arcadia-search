# "use strict"

SearchCtrl = ($scope, $http, $log,$rootScope,$location) ->

  $scope.reverse = true
  $scope.novels = [count:0,data:[]]
  $scope.indexphp = "/php/index.php/novels/"
  # プログレスアイコン 表示 可/否
  $scope.progress = true
  # 検索フレーズ
  $scope.searchPhrase = ""
  prevSearchPhrase = ""
  # 総件数
  $scope.countAll = $scope.novels.length
  # 現在表示中のページ番号
  $scope.currentPage = 1
  # 表示件数
  $scope.viewCount = 50
  $scope.resultNone = true;
  $scope.updatedFavoriteShown = false;
  $scope.updatedFavorite = []
  $scope.updatedFavoritePredicate = 'updated'

  $scope.ARCADIA_URL = "//www.mai-net.net/bbs/sst/sst.php"
  $scope.ARCADIA_BBS_OPTION =  "?act=dump&cate=all&n=0&count=1&all="
  $scope.ARCADIA_BBS_TIRAURA_OPTION =  "?act=dump&cate=tiraura&n=0&count=1&all="
  $scope.error ={
    exist:false
    message:''
  }
  $scope.info ={
    exist:false
    timeoutDefault:1100
    timeout:1100
    messages:[]
    message:''
  }

  # ページネーションを現在ページから何件表示するか
  displayPageMax = 2
  # 現在ページ番号
  $scope.nowPageNo = 1
  $scope.favorites = {}

  $scope.parseNovelUpdateAt = (novel)->
    return Date.parse(novel.novel_updated_at)

  ###
    JSONファイル取得が成功した場合のハンドラです。
    表示するデータを設定します。
    @param data 取得データ
    @param status HTTP Status
    @param headers HTTP ヘッダー
    @param config
  ###
  _handleSearch = (data,status,headers,config)->

    $scope.novels = data.data
    $log.log "novels count:#{$scope.novels.length}"
    _setCount(data.count)
    $scope.createPagination() if $scope.isPagination
    $scope.checkResultNone()
    _initializeFavorites()

    if $scope.searchPhrase 
      $rootScope.title = prevSearchPhrase = $scope.searchPhrase
      $rootScope.title += " - "
    else
      $rootScope.title = ""

    $scope.progress = false
    if $scope.resultNone
      _setErrorMessage("#{$scope.searchPhrase}に一致する情報が見つかりませんでした")
    $('body').scrollTop(0)

  ###
    JSONファイル取得エラー時のハンドラです。
    エラーメッセージを設定します。
  ###
  _errorHandler = (data,status,headers,config) ->
    if data
      error = data.match /データベースサーバに接続できません/

      message = "データベースに接続できません。" +
      " 時間をおいてアクセスしてみてください。"+
      "それでも解決しない場合は管理者に連絡をしてください。"
      _setErrorMessage(message)

    $log.log "search error :server #{status}"
    $log.log headers()
    $log.log config
    console.debug "error:#{error}"

    $scope.progress = false

  ###
    件数に関する数値を設定します。
    @param count 取得件数
  ###
  _setCount = (count) ->
    $scope.countAll = count
    $scope.pageMax = Math.ceil $scope.countAll / $scope.viewCount
    $scope.isPagination = $scope.countAll > $scope.viewCount
    $scope.currentPage = $scope.nowPageNo

  _initializeFavorites = ->
    favorites = $scope.loadFavorites()
    angular.forEach $scope.novels ,(value,key)=>
      id = value.id

      if favorites[id]
        $scope.favorites[id] = favorites[id]
        return

      $scope.favorites[id] = {
        'id':id
        'title':value.title
        'status':false
      }
    $scope.favorites

  ###
  # 更新された小説リストを取得し、チェックリストと比較して更新された
  # チェックリスト内小説データを生成します。
  ###
  $scope.checkUpdatedFavorites = ->
    # url = '/data/past-update.json'
    url = '/php/index.php/novels/search/past/7'
    $http.get(url)
      .success((data,status,headers,config) =>
        _popupUpdatedFav(data)
      )
      .error((data,status,headers,config) =>
        _setErrorMessage("更新された小説一覧が取得出来ませんでした。" +
          "ネットワークの状態を確認してください。") if(status == 404)
        _setErrorMessage("サーバーエラーにより更新された小説一覧が取得出来ませんでした。" +
          "時間をおいてアクセスしてみてください") if(status == 500)
      )

  _popupUpdatedFav = (data) ->
    updatedFavorite = []
    favorites = $scope._initializeFavorites()
    for value in data.data
      if favorites[value.id]
        value.updated = Date.parse(value.novel_updated_at)
        updatedFavorite.push value

    sort_by = (field, reverse, primer)->
     reverse = (reverse) ? -1 : 1;
     return (a,b)->
       a = a[field]
       b = b[field]
       a = primer?(a)
       b = primer?(b)
       return reverse * -1 if (a<b)
       return reverse * 1 if (a>b)
       return 0;

    $scope.updatedFavoriteShown  = true unless updatedFavorite.length == 0
    $scope.updatedFavorite = updatedFavorite
    

  ###
    前へが存在する
    次へが存在する
  ###
  $scope.createPagination = ->
    $log.log "start createPagination"

    _initializePagenation()

    unless _checkCurrentPage(1)
      # 1ページ目は「前へ」を出さない
      $scope.pagination.push {'name':"前へ",'class':"previous",'id':"page-previous"}

    page = _createPagenationNumber()
    $log.log page
    for i in [page.startNumber..page.endNumber]
      $scope.pagination.push {
        'name':i
        'class':_checkCurrentPage(i)+" number"
        'id':"page-#{i}"
        'disabled': if _checkCurrentPage(i) is 'active' then true else false
        }

    unless $scope.nowPageNo == $scope.pageMax
      # 最後のページは「次へ」を出さない
      $scope.pagination.push {'name':"次へ",'class': "next",'id':"page-next"}


  ###
  # ページ番号の範囲を計算する
  # 現在ページから±$scope.pagemaxの範囲を計算
  # 現在ページ 1 → 1～5
  # 現在ページ 7 → 5～9
  # @return {Object}
  #           startNumber: 開始ページ番号
  #           endNumber: 終了ページ番号
  ###
  _createPagenationNumber = ->

    # 終了ページ番号を計算する
    if (displayPageMax + $scope.nowPageNo) < $scope.pageMax
      end = $scope.nowPageNo + displayPageMax
      if $scope.pageMax <= displayPageMax * 2 +1
        end = $scope.pageMax
      else if end <= displayPageMax * 2 +1
        end = displayPageMax * 2 +1
    else
      end = $scope.pageMax

    # 開始ページ番号を計算する
    if ($scope.nowPageNo - displayPageMax) > 0
      start = $scope.nowPageNo - displayPageMax
      start = 1  if $scope.pageMax <= displayPageMax * 2 +1
    else
      start = 1

    return {'startNumber':start , 'endNumber':end}

  ###
  ページネーション用のオブジェクトを生成します。
  ###
  _initializePagenation = ->
    $scope.pagination = []

  ###
  渡された引数が現在ページかどうかチェックします
  @param {Integer} i チェックする番号
  @return {String}
          ページ数が一致する = "active"
          それ以外 ""
  ###
  _checkCurrentPage = (i) =>
    if $scope.nowPageNo == i
      "active"
    else
      ""

  ###
    渡された数値を分類し、大きさに応じてクラス名を返却します。
  ###
  $scope.classifyPV = (pv)->
    pv = parseInt(pv)
    if pv >= 2000000    then return "pv-xxlarge" else
      if pv >= 1000000  then return "pv-xlarge" else
      if pv >= 500000   then return "pv-large" else
      if pv >= 300000   then return "pv-medium" else
      if pv >= 100000   then return "pv-small" else
      if pv < 100000    then return "pv-xsmall"
      else
        return 'pv-xsmall'

  ###
  検索結果が存在しないかをチェックします
  ###
  $scope.checkResultNone = ->
    $scope.resultNone = $scope.countAll is 0

  ###
  エラーメッセージを設定します
  ###
  _setErrorMessage = (message) ->
    $scope.error.message = message
    $scope.error.exist = true

  ###
  エラーメッセージをクリアします
  ###
  _clearErrorMessage = ->
    $scope.error.message = ""
    $scope.error.exist = false

  ###
  指定したページへ移動します
  ###
  $scope.pageMove = (pageNumber) ->
    _setNowPageNo(pageNumber)
    $location.search({"q":prevSearchPhrase,'page':$scope.nowPageNo})

  ###
  現在ページ番号を設定します。
  ###
  _setNowPageNo = (pageNumber) ->
    $log.log "☆ start _setNowPageNo pageNumber#{pageNumber} $scope.nowPageNo #{$scope.nowPageNo}"
    if pageNumber is "次へ"
      $scope.nowPageNo += 1
    else if pageNumber is "前へ"
      $scope.nowPageNo -= 1
    else if isOutOfPageRenge(pageNumber)
      _setErrorMessage "範囲外の値が指定されました。1ページ目へ移動します。"
      $scope.nowPageNo = 1
      $log.log " if pageNumber > $scope.pageMax #{$scope.pageMax} pageNumber#{pageNumber} $scope.nowPageNo #{$scope.nowPageNo}"
    else if !_.isUnsignedInt(pageNumber)
      _setErrorMessage "範囲外の値が指定されました。1ページ目へ移動します。"
      $scope.nowPageNo = 1
      $log.log "!_.isUnsignedInt pageNumber#{pageNumber} $scope.nowPageNo #{$scope.nowPageNo}"
    else
      $scope.nowPageNo = pageNumber
    $log.log "☆ end   _setNowPageNo $scope.nowPageNo #{$scope.nowPageNo}"

  ###
  指定された番号が範囲外かどうかチェックします。
  ###
  isOutOfPageRenge = (pageNumber) ->
    return pageNumber > $scope.pageMax

  ###
  指定されたURLを取得し、各種データを設定します。
  @param {String} url URL
  ###
  _fetchSearch = (url) ->
    $log.log "☆ start fetch url : #{url}  $scope.nowPageNo #{$scope.nowPageNo}"

    $http.get(url)
      .success(_handleSearch)
      .error(_errorHandler)

    urlHash = $location.search()
    urlQuery = urlHash["q"]
    pageQuery = urlHash["page"]
    $location.search({"q":$scope.searchPhrase,'page':$scope.nowPageNo})
    $log.log urlHash
    $log.log "★ end   fetch url query = #{urlQuery}
      pageQuery #{pageQuery}
      $scope.nowPageNo #{$scope.nowPageNo}
      pageMax:#{$scope.pageMax}"

  ###
  クラス内のデータを使用して検索を行います。
  ###
  $scope.search = ()->
    $log.log "☆ start search"
    $scope.progress = true

    _checkCangeSearchPhrase()
    url = "#{$scope.indexphp}index/page/#{$scope.nowPageNo}"

    if $scope.searchPhrase
      # searchPhraseが変わっていなくてもページ番号を付けてfetchする
      encodedSearchPhrase = encodeURIComponent($scope.searchPhrase)
      url = "#{$scope.indexphp}search/q/#{encodedSearchPhrase}/page/#{$scope.nowPageNo}"

    _fetchSearch(url)

    $log.log "★ end   search"

  ###
  クラス内データを使わず、新たに検索を行います。
  ###
  $scope.searchNew = ()->
    $log.log "☆ start searchNew"
    _setNowPageNo(1)
    $location.search({"q":$scope.searchPhrase,'page':1})
    $log.log "★ end   searchNew"

  ###
  カテゴリを付与して検索を行います。
  ###
  $scope.searchCategory =->
    $log.log "☆ start searchCategory"
    _setNowPageNo(1)
    $location.search({"q":$scope.searchPhrase,'page':1,'category':$scope.category})
    $log.log "★ end   searchCategory"

  ###
  クラス内データをクリアするためのメソッドです。
  ###
  _cleanData = ->
    _clearErrorMessage()

  ###
  検索フレーズが変更されたかどうかをチェックします。
  ###
  _checkCangeSearchPhrase = ->
    unless _isEqualSearchPhrase()
      _cleanData()
      return true
    false

  ###
  前回検索フレーズと今回検索フレーズが同一かどうか判別します。
  ###
  _isEqualSearchPhrase = ()->
    return true if prevSearchPhrase is $scope.searchPhrase
    return false

  ###
  新たにユーザーIDをキーにlocalStorageを生成します。
  ###
  createLocalStoage = ()->
    id = "#{Math.random()}#{new Date()}"
    localStoage.id = SHA512(id)

  _setWorning = (message) ->
    $scope.worn.message = message
    $scope.worn.exist = true

    sec = 2
    timeout = sec * 1000
    setTimeout(
      ()=>
        $log.worn "$scope.worn.exist = false"
        $scope.$apply()
    ,timeout)

  ###
  インフォメーションメッセージを設定します。
  ###
  _setInfomation = (message) ->
    info = $scope.info
    info.messages.push "#{message}"
    info.exist = true
    info.timeout = info.timeout + info.timeoutDefault
    $log.log "info.timeout #{info.timeout}"

    #全ての表示エフェクトが終わった際に非表示にするためTimeoutを設定
    setTimeout(
      ()->
        info.timeout -= $scope.info.timeoutDefault
        info.messages = [] if info.timeout is info.timeoutDefault
        info.exist = false unless info.messages.length
        $scope.$apply()
    ,2500)

  ###
  渡された小説をチェックリスト登録をトグルします。
  @param ｛Object} novel id と titleが必須です。
  ###
  $scope.toggleFavorite = (novel)->
    unless $scope.favorites[novel.id]?.status
      $scope.addFavorite(novel)
    else
      $scope.removeFavorite(novel)
      
    $scope.checkUpdatedFavorites()
    $scope.favorites

  ###
  渡された小説をチェックリストに登録します。
  @param ｛Object} novel id と titleが必須です。
  ###
  $scope.addFavorite = (novel)->
    $scope.favorites[novel.id] = {
      'id':novel.id
      'title':novel.title
      'status':true
    }
    _setInfomation "#{novel.title} をチェックリストに追加しました。"
    $scope.saveFavorite()
    $scope.favorites

  ###
  渡された小説のチェックリスト登録を解除します。
  @param ｛Object} novel id と titleが必須です。
  ###
  $scope.removeFavorite = (novel)->
    $scope.favorites[novel.id].status = false
    _setInfomation "#{novel.title} をチェックリストからはずしました。"
    $scope.saveFavorite()
    $scope.favorites

  ###
  チェックリスト登録を全て解除します。
  @param ｛Object} novel id と titleが必須です。
  ###
  $scope.removeAllFavorites = ->
    angular.forEach $scope.favorites, (value,key)=>
      value.status = false
    $scope.saveFavorite()

  ###
  チェックリスト登録を参照し、アイコン状態を取得します。
  ###
  $scope.getFavoriteIcon = (favorite)->
    if favorite?.status then 'icon-star' else 'icon-star-empty'

  ###
  チェックリスト登録をLocalStorageに保存します
  ###
  $scope.saveFavorite = ->
    json = JSON.stringify(_takeUserFavorite())

    localStorage?.favorites = json
    json

  ###
  チェックリスト登録されているモノのみを抽出します。
  ###
  _takeUserFavorite = ->
    result = {}

    angular.forEach $scope.favorites,(value,key)=>
      result[value.id] = value if value.status

    result

  ###
  LocalStorageからチェックリストをロードします。
  ###
  $scope.loadFavorites = ->
    localFavString = localStorage?.favorites if  localStorage?.favorites?
    localFav = {}
    localFav = JSON.parse(localFavString) if localFavString
    angular.forEach localFav,(value,key)=>
      $scope.favorites[key] = value

    localFav

  _start = ->
    $log.log "☆ start _start"
    urlHash = $location.search()
    urlQuery = urlHash["q"]
    category = urlHash["category"]
    pageQuery = parseInt(urlHash["page"])

    if urlQuery
      # 初期状態でURLにクエリが設定されていたならば
      $log.log "url query = #{urlQuery} pageQuery #{pageQuery} category:#{category}"
      $log.log urlHash
      $scope.searchPhrase =  decodeURIComponent(urlQuery)

    $scope.nowPageNo = pageQuery if pageQuery
    $scope.search()
    $scope.checkUpdatedFavorites()

    $log.log "★ end   _start
      $scope.nowPageNo:#{$scope.nowPageNo}
      currentPage:#{$scope.currentPage}
      pageMax:#{$scope.pageMax}"

  _start()

angular.module("myApp.controllers", [])
.controller("SearchCtrl", [
  "$scope"
  "$http"
  "$log"
  "$rootScope"
  "$location"
  SearchCtrl
])
.controller("CategoriesCtrl",[
  '$scope'
  '$http'
  '$log'
  ($scope,$http,$log)->
    $scope.categories = []

    get = ->
      $http.get('/data/categories.json')
        .success(
          (json)=>
            $log.log "categories success: "
            $log.log json
            $scope.categories = json
        )
        .error(
          (data,status,header,config) =>
            $log.log 'error:categories json:'+"#{data} #{status} "
            $log.log header()
            $log.log config
        )

    get()
])
