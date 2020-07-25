require 'test_helper'
require 'minitest/mock'

class UrlApiTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = false

  test 'POST /urls creates a slug for an given url, stores and returns it' do
    target = 'https://juntin.app'

    post '/urls', params: { data: { target: target } }, as: :json

    expected_response = {
      'data' => {
        'url' => { 'target' => target, 'slug' => '1', 'hits' => 0}
      }
    }

    assert_response :created
    assert_equal(expected_response, response.parsed_body)
    assert_equal(target, Url.find_by_slug('1').target)
  end

  test 'POST /urls with invalid url returns an error' do
    post '/urls', params: { data: { target: 'not-an-url'} }, as: :json

    expected_response = {
      'errors' => [
        'type' => 'Invalid',
        'message' => 'The given URL is not valid'
      ]
    }

    assert_response :unprocessable_entity
    assert_equal(expected_response, response.parsed_body)
  end

  test 'POST /urls returns and error if it could not save the Url' do
    Url.stub :new, Url.new do
      post '/urls', params: { data: { target: 'https://juntin.app'} }, as: :json

      assert_response :unprocessable_entity
      assert_not_empty(response.parsed_body["data"]["errors"])
    end
  end

  test 'GET /urls/:slug returns an URL data for a given slug if it exists' do
    target = 'http://juntin.app'
    hits = 20

    record = Url.create!(target: target, hits: hits)

    get "/urls/#{record.slug}"

    expected_response = {
      'data' => {
        'url' => { 'target' => target, 'slug' => record.slug, 'hits' => hits }
      }
    }

    assert_response :success
    assert_equal(expected_response, response.parsed_body)
  end

  test 'GET /urls/:slug returns 404 the URL for a given slug does not exist' do
    get '/urls/whatever'

    expected_response = {
      'errors' => [
        { 'type' => 'NotFound', 'message' => 'Could not find an URL for the given slug'}
      ],
    }

    assert_response :not_found
    assert_equal(expected_response, response.parsed_body)
  end

  test 'GET /urls returns a list of URLs ordered by hits count' do
    url1 = Url.create(target: 'http://juntin.app/br', hits: 10)
    url2 = Url.create(target: 'http://juntin.app/other', hits: 15)
    url3 = Url.create(target: 'http://juntin.app/other', hits: 10)

    get '/urls'

    expected_response = {
      'data' => {
        'urls' => [
          { 'target' => url2.target, 'slug' => url2.slug, 'hits' => url2.hits},
          { 'target' => url1.target, 'slug' => url1.slug, 'hits' => url1.hits},
          { 'target' => url3.target, 'slug' => url3.slug, 'hits' => url3.hits}
        ]
      }
    }

    assert_response :success
    assert_equal(expected_response, response.parsed_body)
  end

  test 'GET /urls?limit=:limit returns a list of URLs the first N urls based on the limit param' do
    Url.create!(target: 'http://juntin.app/br', hits: 10)
    url1 = Url.create!(target: 'http://juntin.app/other', hits: 20)
    url2 = Url.create!(target: 'http://juntin.app/other', hits: 25)

    get '/urls?limit=2'

    expected_response = {
      'data' => {
        'urls' => [
          { 'target' => url2.target, 'slug' => url2.slug, 'hits' => url2.hits},
          { 'target' => url1.target, 'slug' => url1.slug, 'hits' => url1.hits}
        ]
      }
    }

    assert_response :success
    assert_equal(expected_response, response.parsed_body)
  end

  test 'PATCH /urls/:slug/hit increases the hit count by 1' do
    url = Url.create!(target: 'http://juntin.app')

    assert_equal(url.hits, 0)

    patch "/urls/#{url.slug}/hit"
    assert_response :no_content
    assert_equal(url.reload.hits, 1)

    patch "/urls/#{url.slug}/hit"
    assert_response :no_content
    assert_equal(url.reload.hits, 2)
  end


  test 'PATCH /urls/:slug/hit returns 404 if the slug does not exist' do
    patch "/urls/whatever/hit"

    expected_response = {
      'errors' => [
        { 'type' => 'NotFound', 'message' => 'Could not find an URL for the given slug'}
      ],
    }

    assert_response :not_found
    assert_equal(expected_response, response.parsed_body)
  end

  test 'PATCH /urls/:slug/hit returns 422 if could not update the record' do
    Url.stub :find_by_slug, Url.new do
      patch "/urls/whatever/hit"

      assert_response :unprocessable_entity
      assert_not_empty(response.parsed_body["data"]["errors"])
    end
  end
end
