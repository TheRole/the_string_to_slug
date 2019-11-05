# coding: UTF-8
require 'spec_helper'

describe 'StringToSlug' do
  context 'Check `to_slug_param_base` method' do
    before(:each) { I18n.locale = :en }
    after(:all) { I18n.locale = :en }

    it "is true" do
      I18n.locale = :ru
      str = "Hello    world its me                 Привет Мир 際          "
      expect(str.to_slug_param_base).to eq("hello-world-its-me-privet-mir")
    end

    it "is true" do
      I18n.locale = :ru
      str = "際   際 際 Hello    world its me           際      Привет Мир 際   "
      expect(str.to_slug_param_base).to eq("hello-world-its-me-privet-mir")
    end

    it "is true" do
      str = "際   際 際 Hello    world its me           際      Привет Мир 際   "
      expect(str.to_slug_param_base).to eq("hello-world-its-me")
    end

    it "is true" do
      I18n.locale = :ru
      expect("hey_-.+_)(/\\Мир".to_slug_param_base).to eq("hey-mir")
    end

    it "is true" do
      expect("hey_-.+_)(/\\Мир".to_slug_param_base).to eq("hey")
    end

    it "is true" do
      I18n.locale = :en
      expect("Документ.doc".to_slug_param_base).to eq("doc")
    end

    it "is true" do
      expect(:"Документ.doc".to_slug_param_base(locale: :en)).to eq("doc")
    end

    it "is true" do
      expect("Документ.doc".to_slug_param_base(locale: :en)).to eq("doc")
    end

    it "is true" do
      expect("Документ.doc".to_slug_param_base(sep: '_', locale: :en)).to eq("doc")
    end

    it "is true" do
      expect(:"Документ.doc".to_slug_param_base(sep: '_', locale: :en)).to eq("doc")
    end

    it "is true" do
      I18n.locale = :ru
      expect("Документ.doc".to_slug_param_base).to eq("dokument-doc")
    end

    it "is true" do
      expect("Документ.doc".to_slug_param_base(locale: :ru)).to eq("dokument-doc")
    end

    it "is true" do
      expect(:"Документ.doc".to_slug_param_base(locale: :ru)).to eq("dokument-doc")
    end

    it "is true" do
      expect("Документ.doc".to_slug_param_base(sep: '_', locale: :ru)).to eq("dokument_doc")
    end

    it "is true" do
      expect(:"Документ.doc".to_slug_param_base(sep: '_', locale: :ru)).to eq("dokument_doc")
    end
  end

  context 'Check `to_url` method' do
    before(:each) { I18n.locale = :ru }
    after(:all) { I18n.locale = :en }

    it 'should be true' do
      str = "Hello    world its me                 Привет Мир 際          "
      expect(str.to_url).to eq("hello-world-its-me-priviet-mir-ji")
    end

    it 'should be true' do
      str = "際   際 際 Hello    world its me           際      Привет Мир 際   "
      expect(str.to_url).to eq("ji-ji-ji-hello-world-its-me-ji-priviet-mir-ji")
    end

    it 'should be true' do
      str = "Документ.doc"
      expect(str.to_url).to eq("dokumient-tochka-doc")
    end

    it 'should be true' do
      I18n.locale = :en
      str = "Документ.doc"
      expect(str.to_url).to eq("dokumient-dot-doc")
    end

    it 'should be true' do
      I18n.locale = :ru
      str = "hey_-.+_)(/\\Мир"
      expect(str.to_url).to eq("hey-tochka-plius-sliesh-sliesh-mir")
    end

    it 'should be true' do
      I18n.locale = :en
      str = "hey_-.+_)(/\\Мир"
      expect(str.to_url).to eq("hey-dot-plus-slash-slash-mir")
    end
  end

  context 'String tests with fallback' do
    after(:all) { I18n.locale = :en }

    it 'should be true' do
      I18n.locale = :en
      str = "Hello world its me Привет Мир 際"
      expect(str.to_smart_slug_param(tolerance: 90)).to eq("hello-world-its-me-priviet-mir-ji")
      expect(str.to_smart_slug_param(tolerance: 50)).to eq("hello-world-its-me-privet-mir")
    end

    it 'should be true' do
      I18n.locale = :ru
      str = "Hello world its me Привет Мир 際"
      expect(str.to_smart_slug_param(tolerance: 90)).to eq("hello-world-its-me-priviet-mir-ji")
      expect(str.to_smart_slug_param(tolerance: 50)).to eq("hello-world-its-me-privet-mir")
    end
  end

  context 'String tests' do
    it 'should be true' do
      expect("Привет Мир! Hello world!".to_slug_param).to eq("privet-mir-hello-world")
      expect("Документ.doc".to_slug_param).to eq("dokument-doc")
    end

    it 'When wrong translation' do
      expect("Привет Мир! Hello world!".to_slug_param(locale: :en)).to eq("hello-world")
      expect("Документ.doc".to_slug_param(locale: :en)).to eq("doc")
    end
  end

  context 'Filename test' do
    it 'should be true' do
      expect("/doc/dir/test/document.doc".to_slug_param).to     eq("doc-dir-test-document-doc")

      expect("/doc/dir/test/document.doc".slugged_filename).to  eq("document.doc")
      expect("/доки/dir/тест/документ.doc".slugged_filename).to eq("dokument.doc")
      expect("/доки/dir/тест/документ".slugged_filename).to     eq("dokument")
      expect("/доки/dir/тест/доку мент".slugged_filename).to    eq("doku-ment")

      expect(String.slugged_filename("/доки/dir/тест/доку мент")).to eq("doku-ment")
    end

    it 'When wrong translation' do
      expect("/doc/dir/test/document.doc".to_slug_param(locale: :ru)).to     eq("doc-dir-test-document-doc")
      expect("/doc/dir/test/document.doc".slugged_filename(locale: :ru)).to  eq("document.doc")

      expect("/доки/dir/тест/документ.doc".slugged_filename(locale: :en)).to eq(".doc")
      expect("/доки/dir/тест/документ".slugged_filename(locale: :en)).to     eq("")
      expect("/доки/dir/тест/доку мент".slugged_filename(locale: :en)).to    eq("")

      expect(String.slugged_filename("/доки/dir/тест/доку мент", locale: :en)).to eq("")
    end
  end

  context 'Full path to file' do
    it 'should be true' do
      expect("/doc/dir/test/document.doc".slugged_filepath).to  eq("/doc/dir/test/document.doc")
      expect("/доки/dir/тест/документ.doc".slugged_filepath).to eq("/доки/dir/тест/dokument.doc")
      expect("/доки/dir/тест/документ".slugged_filepath).to     eq("/доки/dir/тест/dokument")
      expect("/доки/dir/тест/доку мент".slugged_filepath).to    eq("/доки/dir/тест/doku-ment")

      expect(String.slugged_filepath("/доки/dir/тест/доку мент")).to eq("/доки/dir/тест/doku-ment")
    end

    it 'When wrong translation' do
      expect("/doc/dir/test/document.doc".slugged_filepath(locale: :en)).to  eq("/doc/dir/test/document.doc")
      expect("/доки/dir/тест/документ.doc".slugged_filepath(locale: :en)).to eq("/доки/dir/тест/.doc")

      expect("/доки/dir/тест/документ".slugged_filepath(locale: :en)).to     eq("/доки/dir/тест/")
      expect("/доки/dir/тест/доку мент".slugged_filepath(locale: :en)).to    eq("/доки/dir/тест/")

      expect(String.slugged_filepath("/доки/dir/тест/доку мент", locale: :en)).to eq("/доки/dir/тест/")
    end
  end

  context 'sep' do
    it 'should be true' do
      expect("Привет Мир! Hello world!".to_slug_param(sep: '_')).to eq("privet_mir_hello_world")
      expect("Документ.doc".to_slug_param(sep: '_')).to eq("dokument_doc")

      expect("/доки/dir/тест/документ".slugged_filepath(sep: '_')).to      eq("/доки/dir/тест/dokument")
      expect("/доки/dir/тест/доку мент".slugged_filepath(sep: '_')).to     eq("/доки/dir/тест/doku_ment")
      expect("/доки/dir/тест/доку мент".slugged_filename(sep: '_')).to eq("doku_ment")
    end
  end

  context "spec chars" do
    it "should works" do
      expect("[$&+,:;=?@Hello world!#|'<>.^*()%!-]".to_slug_param).to eq('hello-world')
    end

    it "should works" do
      expect("教師 — the-teacher".to_slug_param).to eq('the-teacher')
      expect("Hello ^, I'm here!".to_slug_param).to eq('hello-i-m-here')
    end

    it "should works" do
      expect("HELLO---WorlD".to_slug_param(sep: '_')).to eq('hello_world')
    end

    it "should works" do
      str = "__...HELLO-___--+++--WorlD----__&&***...__.---"

      expect(str.to_slug_param).to eq('hello-world')
      expect(str.to_slug_param(sep: '_')).to eq('hello_world')
      expect(str.to_slug_param(sep: '+')).to eq('hello+world')
    end

    it "should works" do
      str = "Ilya zykin aka   Killich, $$$ aka the-teacher"
      expect(str.to_slug_param(sep: '+')).to eq("ilya+zykin+aka+killich+aka+the+teacher")
    end

    it "should works" do
      str = "Илья Николаевич, прекратите кодить по выходным!".to_sym
      expect(str.to_slug_param).to eq("ilya-nikolaevich-prekratite-kodit-po-vyhodnym")
    end
  end

  context 'Scopes' do
    it "should work with Nested Controller Name" do
      class PagesController < ApplicationController; end
      ctrl = PagesController.new
      expect(ctrl.controller_path.to_slug_param).to eq('pages')
    end

    it "should work with Nested Controller Name" do
      module Admin; end
      class Admin::PagesController < ApplicationController; end
      ctrl = Admin::PagesController.new
      expect(ctrl.controller_path.to_slug_param).to eq('admin-pages')
    end

    it "should work with Nested Controller Name" do
      module Admin; end
      class Admin::PagesController < ApplicationController; end
      ctrl = Admin::PagesController.new
      params = { sep: '_' }
      expect(ctrl.controller_path.to_slug_param(params)).to eq('admin_pages')
    end
  end
end
