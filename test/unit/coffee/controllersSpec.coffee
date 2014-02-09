"use strict"

# jasmine specs for controllers go here
describe "SearchCtrlは", ->
  location = scope = elm = ctrl = $http = $httpBackend = null

  beforeEach module("myApp.controllers")

  beforeEach inject(($rootScope, $controller,_$httpBackend_,$injector ,$location) ->
    scope = $rootScope.$new()
    $httpBackend =  $injector.get('$httpBackend')

    $httpBackend.whenGET('/php/index.php/novels/index/1').respond({
      count:1,
      data:[{
      category:"その他"
      id:22476
      title:"Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】"
      novelist:"ＭＲＺ"
      novelCount:73
      reviewCount:435
      pv:196185
      update_at:"3/26 4:48"
      }]
    })
    ctrl = $controller("SearchCtrl",{
      $scope:     scope
      $rootScope: $rootScope
      $location:  $location
    })
    location = $location
  )


  it "初期化時に小説リストを取得すること", ->
    $httpBackend.flush()
    expect(ctrl).not.toBeNull()
    expect(scope.novels[0].id).toEqual 22476
    expect(scope.novels[0].title).toEqual "Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】"
    expect(scope.novels[0].novelist).toEqual "ＭＲＺ"
    expect(scope.novels[0].novelCount).toEqual 73
    expect(scope.novels[0].reviewCount).toEqual 435
    expect(scope.novels[0].pv).toEqual 196185
    expect(scope.novels[0].update_at).toEqual "3/26 4:48"
    expect(scope.novels[0].category).toEqual "その他"

  describe '検索で',->

    describe '正常系の場合、',->
      beforeEach ->
        url = "/php/index.php/novels/search/#{encodeURIComponent('宿命の聖母')}/page/1"
        $httpBackend.whenGET(url).respond({
          count:432,
          data:[{
            category:"スクエニ"
            id:7208
            title:"ドラゴンクエスト５　宿命の聖母（DQ5　女主人公再構成　完結済　補......	"
            novelist:"航海長"
            novelCount:86
            reviewCount:206
            pv:267419
            update_at:"2012/09/16 23:21:04"
          }]
        })
        scope.searchPhrase = "宿命の聖母"

      it "一ページ目のページングデータが生成できること",->
        scope.search()
        $httpBackend.flush()

        expect(scope.countAll).toEqual 432
        expect(scope.pageMax).toEqual 9
        expect(scope.isPagination).toBeTruthy
        result = [
          {'name':1,'class':"active number",'id':"page-1" ,"disabled":true}
          {'name':2,'class':" number",'id':"page-2","disabled":false}
          {'name':3,'class':" number",'id':"page-3","disabled":false}
          {'name':4,'class':" number",'id':"page-4","disabled":false}
          {'name':5,'class':" number",'id':"page-5","disabled":false}
          {'name':'次へ', 'class':'next','id':"page-next"}
        ]
        expect(scope.pagination).toEqual(result)

      it "検索結果を取得するためのURLリクエストができること",->
        scope.search()
        $httpBackend.flush()
        expect(scope.novels[0].id).toEqual 7208
        expect(scope.novels[0].title).toMatch(/宿命の聖母/)
        expect(scope.novels[0].novelist).toEqual "航海長"
        expect(scope.novels[0].novelCount).toEqual 86
        expect(scope.novels[0].reviewCount).toEqual 206
        expect(scope.novels[0].pv).toEqual 267419
        expect(scope.novels[0].update_at).toEqual "2012/09/16 23:21:04"
        expect(scope.novels[0].category).toEqual "スクエニ"


      it "途中ページのページングデータが生成できること",->
        scope.search()

        url = "/php/index.php/novels/search/#{encodeURIComponent('宿命の聖母')}/page/7"
        $httpBackend.whenGET(url).respond({
          count:432,
          data:[{
            category:"スクエニ"
            id:7200
            title:"ドラゴンクエスト3 宿命の聖母"
            novelist:"航海長MAX"
            novelCount:90
            reviewCount:210
            pv:2888888
            update_at:"2012/09/16 23:21:04"
          }]
        })

        scope.pageMove(7)
        $httpBackend.flush()

        expect(scope.countAll).toEqual 432
        expect(scope.pageMax).toEqual 9
        expect(scope.isPagination).toBeTruthy
        expect(scope.currentPage).toEqual(7)

        result = [
          {'name':'前へ', 'class':'previous','id':"page-previous"}
          {'name':5,'class':" number",'id':"page-5","disabled":false}
          {'name':6,'class':" number",'id':"page-6","disabled":false}
          {'name':7,'class':"active number",'id':"page-7","disabled":true}
          {'name':8,'class':" number",'id':"page-8","disabled":false}
          {'name':9,'class':" number",'id':"page-9","disabled":false}
          {'name':'次へ', 'class':'next','id':"page-next"}
        ]
        expect(scope.pagination).toEqual(result)

      it "URLに検索ワードを付与して検索できること", inject(($location,$rootScope) ->
        $location.html5mode = false
        $location.hashPrefix = "#"
      , ($location,$rootScope) ->
        url = "/search?q=宿命の聖母"
        $location.path url
        $rootScope.$apply()
        $httpBackend.whenGET(url).respond({
          count:432,
          data:[{
            category:"スクエニ"
            id:7200
            title:"ドラゴンクエスト3 宿命の聖母"
            novelist:"航海長MAX"
            novelCount:90
            reviewCount:210
            pv:2888888
            update_at:"2012/09/16 23:21:04"
          }]
        })
        scope.search()
        $httpBackend.flush()
        expect(scope.countAll).toEqual 432
        expect(scope.pageMax).toEqual 9
        expect(scope.isPagination).toBeTruthy
        expect(scope.currentPage).toEqual(1)
      )

      it "お気に入りチェックリストを初期化出来ること",->
        $httpBackend.flush()

        expect(scope.favorite).toEqual({
            22476 : { id : 22476
              , title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
              , status : false }
        })

      it "お気に入りチェックリストに小説を追加出来ること",->
        $httpBackend.flush()
        novel =
            category:"スクエニ"
            id:7200
            title:"ドラゴンクエスト3 宿命の聖母"
            novelist:"航海長MAX"
            novelCount:90
            reviewCount:210
            pv:2888888
            update_at:"2012/09/16 23:21:04"

        expect(scope.addFavorite(novel)).toEqual(
            22476 :
              id : 22476
              title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
              status : false
            7200 :
              id:7200
              title:"ドラゴンクエスト3 宿命の聖母"
              status :true
        )

      it "お気に入りチェックリストの小説を削除出来ること",->
        $httpBackend.flush()
        novel =
          category:"スクエニ"
          id:7200
          title:"ドラゴンクエスト3 宿命の聖母"
          novelist:"航海長MAX"
          novelCount:90
          reviewCount:210
          pv:2888888
          update_at:"2012/09/16 23:21:04"

        scope.favorite =
            22476 :
              id : 22476
              title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
              status : false
            7200 :
              id:7200
              title:"ドラゴンクエスト3 宿命の聖母"
              status :true

        expect(scope.removeFavorite(novel)).toEqual(
            22476 :
              id : 22476
              title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
              status : false
            7200 :
              id:7200
              title:"ドラゴンクエスト3 宿命の聖母"
              status :false
        )

      it "お気に入りチェックリストの小説の追加削除をトグル出来ること",->
        $httpBackend.flush()
        scope.favorite =
            22476 :
              id : 22476
              title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
              status : false
            7200 :
              id:7200
              title:"ドラゴンクエスト3 宿命の聖母"
              status :false

        novel =
          category:"スクエニ"
          id:7200
          title:"ドラゴンクエスト3 宿命の聖母"
          novelist:"航海長MAX"
          novelCount:90
          reviewCount:210
          pv:2888888
          update_at:"2012/09/16 23:21:04"

        expect(scope.toggleFavorite(novel)).toEqual(
            22476 :
              id : 22476
              title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
              status : false
            7200 :
              id:7200
              title:"ドラゴンクエスト3 宿命の聖母"
              status :true
        )

        novel =
          category:"その他"
          id:22476
          title:"Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】"
          novelist:"ＭＲＺ"
          novelCount:73
          reviewCount:435
          pv:196185
          update_at:"3/26 4:48"

        expect(scope.toggleFavorite(novel)).toEqual(
            22476 :
              id : 22476
              title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
              status : true
            7200 :
              id:7200
              title:"ドラゴンクエスト3 宿命の聖母"
              status :true
        )

      it "お気に入りチェックリストの小説をお気に入りに入れたモノだけ保存出来ること",->
        $httpBackend.flush()

        scope.favorite = {
          22476 :
            id : 22476
            title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
            status : false
          7200 :
            id:7200
            title:"ドラゴンクエスト3 宿命の聖母"
            status :true
        }

        expect(scope.saveFavorite()).toEqual(
          '{"7200":{"id":7200,"title":"ドラゴンクエスト3 宿命の聖母","status":true}}'
        )

      it "お気に入りチェックリストに入れた小説をJSONで取り出し出来ること",->
        $httpBackend.flush()

        scope.favorite = {
          22476 :
            id : 22476
            title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
            status : false
          7200 :
            id:7200
            title:"ドラゴンクエスト3 宿命の聖母"
            status :true
        }

        expect(scope.saveFavorite()).toEqual(
          '{"7200":{"id":7200,"title":"ドラゴンクエスト3 宿命の聖母","status":true}}'
        )

        scope.favorite = {
          22476 :
            id : 22476
            title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
            status : false
        }

        expect(scope.loadFavorite()).toEqual(
          7200:
            "id":7200
            title:"ドラゴンクエスト3 宿命の聖母"
            status :true
        )
        expect(scope.favorite).toEqual(
          22476 :
            id : 22476
            title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
            status : false
          7200 :
            id:7200
            title:"ドラゴンクエスト3 宿命の聖母"
            status :true
        )

      it "お気に入りチェックリストに有効なデータ入っている場合、初期状態でロードすること",
        inject(($rootScope, $controller,$location) ->
          $httpBackend.flush()

          scope.favorite = {
            22476 :
              id : 22476
              title : 'Masked Rider in Nanoha～仮面ライダー、世界を渡る～【本編完結】'
              status : false
            7200 :
              id:7200
              title:"ドラゴンクエスト3 宿命の聖母"
              status :false
          }

          expect(scope.saveFavorite()).toEqual(
            '{"7200":{"id":7200,"title":"ドラゴンクエスト3 宿命の聖母","status":true}}'
          )

          scope = $rootScope.$new()
          ctrl = $controller("SearchCtrl",{
            $scope:     scope
            $rootScope: $rootScope
            $location:  $location
          })
          $httpBackend.flush()

          expect(scope.toggleFavorite(novel)).toEqual(
              7200 :
                id:7200
                title:"ドラゴンクエスト3 宿命の聖母"
                status :true
          )
        )


    describe '異常系の場合、',->
      beforeEach ->
        url = "/php/index.php/novels/index/1"
        $httpBackend.whenGET(url).respond({
          count:432,
          data:[
            category:"スクエニ"
            id:7208
            title:"ドラゴンクエスト５　宿命の聖母（DQ5　女主人公再構成　完結済　補......  "
            novelist:"航海長"
            novelCount:86
            reviewCount:206
            pv:267419
            update_at:"2012/09/16 23:21:04"
          ]
        })

      xit "存在しないページ番号をアクセスしようとしたならば、エラーメッセージを表示して1ページ目を表示する",->

        scope.pageMove(100)
        $httpBackend.flush()

        expect(scope.countAll).toEqual 432
        expect(scope.pageMax).toEqual 9
        expect(scope.isPagination).toBeTruthy
        expect(scope.currentPage).toEqual(1)
        expect(scope.error.exist).toBeTruthy
        expect(scope.error.message).toMatch(/範囲外の値が指定されました/)

        result = [
          {'name':1,'class':'active number' ,'id':"page-1","disabled":true}
          {'name':2,'class':" number",'id':"page-2","disabled":false}
          {'name':3,'class':" number",'id':"page-3","disabled":false}
          {'name':4,'class':" number",'id':"page-4","disabled":false}
          {'name':5,'class':" number",'id':"page-5","disabled":false}
          {'name':'次へ', 'class':'next','id':"page-next"}
        ]
        expect(scope.pagination).toEqual(result)

      xit "存在しない負のページ番号をアクセスしようとしたならば、エラーメッセージを表示して1ページ目を表示する",->
        url = "/php/index.php/novels/index/page/1"
        $httpBackend.whenGET(url).respond({
          count:432,
          data:[{
            category:"スクエニ"
            id:7208
            title:"ドラゴンクエスト５　宿命の聖母（DQ5　女主人公再構成　完結済　補......  "
            novelist:"航海長"
            novelCount:86
            reviewCount:206
            pv:267419
            update_at:"2012/09/16 23:21:04"
          }]
        })
        scope.pageMove(-1)
        $httpBackend.flush()

        expect(scope.countAll).toEqual 432
        expect(scope.pageMax).toEqual 9
        expect(scope.isPagination).toBeTruthy
        expect(scope.currentPage).toEqual(1)
        expect(scope.error.message).toMatch(/範囲外の値が指定されました/)

        result = [
          { name : 1, class : 'active number' ,'id':"page-1","disabled":true}
          { name : 2, class : ' number' ,'id':"page-2","disabled":false}
          { name : 3, class : ' number' ,'id':"page-3","disabled":false}
          { name : 4, class : ' number' ,'id':"page-4","disabled":false}
          { name : 5, class : ' number' ,'id':"page-5","disabled":false}
          { name : '次へ', class : 'next' ,'id':"page-next","disabled":false}
        ]
        expect(scope.pagination).toEqual(result)

  afterEach =>
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

describe "CategoriesCtrlは", ->
  scope = ctrl = $httpBackend = null
  url = "/partials/categories.json"

  beforeEach module("myApp.controllers")

  beforeEach inject(($rootScope, $controller, $injector) ->
    scope = $rootScope.$new()
    $httpBackend = $injector.get('$httpBackend')
    $httpBackend.whenGET(url).respond([
        {"id":"0","name":"\u30a8\u30f4\u30a1","key_name":"eva"},
        {"id":"1","name":"\u30ca\u30c7\u30b7\u30b3","key_name":"nade"},
        {"id":"2","name":"\u8d64\u677e\u5065","key_name":"akamatu"},
        {"id":"3","name":"TYPE-MOON","key_name":"type-moon"},
        {"id":"4","name":"Muv-luv","key_name":"muv-luv"},
        {"id":"5","name":"\u30b9\u30af\u30a8\u30cb","key_name":"ff"},
        {"id":"6","name":"\u30b5\u30e2\u30f3\u30ca\u30a4\u30c8","key_name":"sammon"},
        {"id":"7","name":"\u3068\u3089\u30cf","key_name":"toraha"},
        {"id":"8","name":"\u690e\u540d\u9ad8\u5fd7","key_name":"gs"},
        {"id":"9","name":"\u30ca\u30eb\u30c8","key_name":"naruto"},
        {"id":"10","name":"\u30bc\u30ed\u9b54","key_name":"zero"},
        {"id":"11","name":"HxH","key_name":"HxH"},
        {"id":"12","name":"\u30aa\u30ea\u30b8\u30ca\u30eb","key_name":"original"},
        {"id":"13","name":"\u305d\u306e\u4ed6","key_name":"etc"},
        {"id":"16","name":"\u30c1\u30e9\u30b7\u306e\u88cf","key_name":"tiraura"}
        ])
    ctrl = $controller("CategoriesCtrl",{
      $scope:     scope
    })
    $httpBackend.flush()
  )

  it "初期状態でカテゴリデータを保持すること",->
    expect(scope.categories.length).toEqual 15
    scope.categories.each

  afterEach(=>
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    )


