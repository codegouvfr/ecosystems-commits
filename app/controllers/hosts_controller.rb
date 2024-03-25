class HostsController < ApplicationController
  def index
    @hosts = Host.all.visible.order('repositories_count DESC, commits_count DESC')
    fresh_when @hosts, public: true
    @scope = Repository.visible.order('last_synced_at DESC').includes(:host)
    @pagy, @repositories = pagy_countless(@scope, items: 10)
  end

  def show
    @host = Host.find_by_name!(params[:id])
    fresh_when @host, public: true
    scope = @host.repositories.visible

    sort = params[:sort].presence || 'last_synced_at'
    if params[:order] == 'asc'
      scope = scope.order(Arel.sql(sort).asc.nulls_last)
    else
      scope = scope.order(Arel.sql(sort).desc.nulls_last)
    end

    @pagy, @repositories = pagy_countless(scope)
  end
end