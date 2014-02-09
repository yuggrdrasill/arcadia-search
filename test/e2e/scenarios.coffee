"use strict"

# http://docs.angularjs.org/guide/dev_guide.e2e-testing
describe "arcadia searcherは", ->
  beforeEach ->
    browser().navigateTo "/index.html"


  #  it('should automatically redirect to /view1 when location hash/fragment is em//pty', function() {
  #    expect(browser().location().url()).toBe("/view1");
  #  });
  describe "/ ルートで", ->
    beforeEach ->
      browser().navigateTo "#/search"

    it "小説タイトルが50件表示されていること", ->
      expect(element("tr[ng-repeat=\"novel in novels\"]"
        , "小説タイトルカウント").count()).toBe 50

    it "検索フィールドが表示されていること", ->
      expect(element("input[type=\"search\"]", "検索フィールド").count()).toBe 1

    it "小説タイトルがリンクされていること", ->
      expect(element("td.table-title a[href^=\"//www.mai-net.net/bbs/sst/sst.php?act=dump\"]"
        , "タイトルリンク").count()).toBe 50

    it "カテゴリが色分けされていること", ->
      expect(element("[class^=\"table-category category-\"]"
        , "カテゴリ色分け").count()).toBe 100

    it "感想板へリンクされていること", ->
      expect(element("td.table-review-count a[href*=impression]"
        , "感想板リンクカウント").count()).toBe 50

    it "記事数が全件表示へリンクされていること", ->
      expect(element("td.table-novel-count a[href*=all_msg]"
        , "記事リンクカウント").count()).toBe 50

    it "検索ボタンクリックで検索が出来ること", ->
      searchPhrase = "ドラゴン"
      input("searchPhrase").enter searchPhrase
      element(":button").click()
      expect(element("td.table-title a").text()
        , "検索結果").toMatch new RegExp(searchPhrase, "g")
      expect(element("td.table-title a").count()
        , "検索結果カウント").toBe 50
      expect(element("#novels-counter").text()).toEqual "83"

    it "検索して件数/現在ページ/最大ページが表示出来ること", ->
      searchPhrase = "オリジナル"
      input("searchPhrase").enter searchPhrase
      element(":button").click()
      expect(element("td.table-title a").text()
        , "検索結果").toMatch new RegExp(searchPhrase, "g")
      expect(element("td.table-title a").count()
        , "検索結果カウント").toBe 50
      expect(element("#novels-counter").text()).toEqual "667"
      expect(element("#current-page-no").text()).toEqual "1"
      expect(element("#page-max").text()).toEqual "14"

    it "検索時にプログレスアイコンが表示されていること", ->
      searchPhrase = "ドラゴン"
      input("searchPhrase").enter searchPhrase
      element(":button").click()
      expect(
          element(
                 'img[src="/img/ajax-loader.gif"]'
                 ).css("display")
          , "検索結果").toEqual "inline"

    it "次へ クリックでページ遷移が出来ること", ->
      element("#page-next").click()
      expect(element("#current-page-no").text()).toEqual "2"

    it "数値 クリックでページ遷移が出来ること", ->
      element("#page-2").click()
      expect(element("#current-page-no").text()).toEqual "2"
      element("#page-3").click()
      expect(element("#current-page-no").text()).toEqual "3"

    # it "検索オプションボタンをクリックしてをカテゴリ検索オプションが表示出来ること",->
    #   element("#menu-category").click()
    #   expect(element("#search-option-category").css("display")
    #     ,"カテゴリオプション").toEqual("block")
    #   expect(element("#search-option-range-updated").css("display")
    #     ,"更新日オプション").toEqual("block")
    #   expect(element("#search-option-title").css("display")
    #     ,"titleオプション").toBe("block")
    #   expect(element("#search-option-novelist").css("display")
    #     ,"投稿者オプション").toEqual("block")
    #   expect(element("#search-option-range-pv").css("display")
    #     ,"PVオプション").toEqual("block")

    it 'スターをクリックしてメッセージが表示されること',->
      element(".icon-star-empty").click()
      expect(element("#messages").css("display"),
        "infoメッセージ").toEqual("block")

    it '！アイコンクリックで更新されたチェックリスト一覧がポップアップすること',->
      element("#showPopup").click()
      expect(element("#showUpdatedFavorite").css("display"),"popup message").toEqual("block")
