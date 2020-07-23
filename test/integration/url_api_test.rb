require 'test_helper'

class UrlApiTest < ActionDispatch::IntegrationTest
  test 'POST /urls creates an URL for an given target, \
        stores and returns with a slug that represents the id' do
    skip 'TODO'
    post '/urls', params: { data: { url: 'http://google.com'} }, as: :json

    expected_response = {
      data: {
        url: { target: 'http://google.com', slug: '1', hits: 0}
      },
      errors: []
    }

    assert_response :created
    assert_equal(expected_response, response.parsed_body)
  end

  test 'POST /urls creates an URL slug as short as possible' do
    skip 'TODO'
    post '/urls', params: { data: { url: 'http://google.com'} }, as: :json

    # TODO: this should be after 62 other record are created on the database
    expected_response = {
      data: {
        url: { target: 'http://google.com', slug: '00', hits: 0}
      },
      errors: []
    }

    assert_response :created
    assert_equal(expected_response, response.parsed_body)
  end

  test 'POST /urls with invalid url returns an error' do
    skip 'TODO'
    post '/urls', params: { data: { url: 'not-an-url'} }, as: :json

    expected_response = {
      data: nil,
      errors: [
        type: 'Invalid',
        message: 'The given URL is not valid'
      ]
    }

    assert_response :bad_request
    assert_equal(expected_response, response.parsed_body)
  end

  test 'GET /urls/:slug returns an URL data for a given slug if it exists' do
    skip 'TODO'
    get '/urls/slug'

    expected_response = {
      data: {
        url: { target: 'google.com', slug: 'slug', hits: 10}
      },
      errors: []
    }

    assert_response :success
    assert_equal(expected_response, response.parsed_body)
  end

  test 'GET /urls/:slug returns 404 the URL for a given slug does not exist' do
    skip 'TODO'
    get '/urls/whatever'

    expected_response = {
      errors: [
        { type: 'NotFound', message: 'Could not found a URL for the given slug'}
      ],
      data: nil
    }

    assert_response :not_found
    assert_equal(expected_response, response.parsed_body)
  end

  test 'GET /urls returns a list of URLs ordered by hits count' do
    skip 'TODO'
    get '/urls'

    expected_response = {
      data: {
        urls: [
          { target: 'google.com', slug: 'slug', hits: 10},
          { target: 'other.com', slug: 'other', hits: 8},
          { target: 'other.com', slug: 'other', hits: 7}
        ],
        errors: []
      }
    }

    assert_response :success
    assert_equal(expected_response, response.parsed_body)
  end

  test 'GET /urls?limit=:limit returns a list of URLs the first N urls based on the limit param' do
    skip 'TODO'
    get '/urls?limit=2'

    expected_response = {
      data: {
        urls: [
          { target: 'google.com', slug: 'slug', hits: 10},
          { target: 'other.com', slug: 'other', hits: 8}
        ],
        errors: []
      }
    }

    assert_response :success
    assert_equal(expected_response, response.parsed_body)
  end

  test 'PATCH /urls/slug increases the hit count by 1' do
    skip 'TODO'
    slug = 'test'

    url = Url.create!(slug: slug, target: 'http://juntin.app')

    assert_equal(url.hits, 0)

    patch "/urls/#{slug}"
    assert_response :no_content
    assert_equal(url.reload!.hits, 1)

    patch "/urls/#{slug}"
    assert_response :no_content
    assert_equal(url.reload!.hits, 2)
  end
end
