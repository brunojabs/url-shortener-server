require './app/serializers/url_serializer'


class UrlsController < ApplicationController
  # GET /urls
  def index
    limit = params['limit']

    urls = if limit
              Url.all.order(hits: :desc).limit(limit.to_i)
            else
              Url.all.order(hits: :desc)
            end

    render json: {
      data:  {
        urls: urls.map { |url| UrlSerializer.serialize(url) }
      }
    }
  end

  # GET /urls/slug
  def show
    url = Url.find_by_slug(params[:slug])

    render json: { data: { url: UrlSerializer.serialize(url) }}, status: :ok
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  # POST /urls
  def create
    target = params[:data][:target]

    unless UrlValidator.valid?(target)
      return render json: {
        errors: [{ type: 'Invalid', message: 'The given URL is not valid'}]
      }, status: :unprocessable_entity
    end

    url = Url.new(target: target)

    if url.save
      render json: { data: { url: UrlSerializer.serialize(url) } }, status: :created, location: url
    else
      render_invalid(url)
    end
  end

  # PATCH /urls/slug/hit
  def hit
    url = Url.find_by_slug(params[:slug])

    if url.update(hits: url.hits + 1)
      render json: { data: { url: UrlSerializer.serialize(url) }}, status: :no_content
    else
      render_invalid(url)
    end
  rescue ActiveRecord::RecordNotFound
    return render_not_found
  end

  private

  def render_not_found
    response = {
      errors: [
        { type: 'NotFound', message: 'Could not find an URL for the given slug' }
      ]
    }

    render json: response, status: :not_found
  end

  def render_invalid(url)
    errors = url.errors.full_messages.map { |message| { type: 'Invalid', message: message } }

    render json: { data: { errors: errors } } , status: :unprocessable_entity
  end
end
