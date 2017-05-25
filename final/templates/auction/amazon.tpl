<div class="row heading">
  <h3 class="notification-page-title">Amazon Search</h3>
  <p>Search and select here the product that you want to sell, directly from the amazon catalog!</p>
</div>
<div class="input-group col-md-12" style="padding-top: 0.5em">
  <label class="sr-only" for="keyword">Product keyword</label>
  <div class="col-md-7 col-xs-12" style="padding-top: 1em;">
    <input type="text" class="form-control" name="keyword" id="keyword" value="{{$keyword}}" placeholder="Product keyword">
  </div>
  <div class="col-md-3 col-xs-6 text-center" style="padding-top: 1em;">
    <label class="sr-only" for="search_index">Product category</label>
    <select class="form-control" name="search_index" id="search_index">
      {foreach $searchIndices as $index}
        {if $index == $searchIndex}
          <option value="{$index}" selected>{$index}</option>
        {else}
          <option value="{$index}">{$index}</option>
        {/if}
      {/foreach}
    </select>
  </div>
  <div class="col-md-2 col-xs-6 text-center" style="padding-top: 1em;">
    <button type="button" class="btn btn-default searchAmazon"><i class="glyphicon glyphicon-search"></i>  Search</button>
  </div>
</div>
<div class="row">
  {if count($items) == 0}
    <div class="container-fluid" style="padding: 1.5em;">
      <div class="row-fluid">
        <div class="empty-content text-center">
          <i class="fa fa-frown-o fa-3x" aria-hidden="true"></i>
          <h3>There are no results that match your search</h3>
        </div>
      </div>
    </div>
  {else}
    <div class="table-responsive" style="margin: 0.5em">
      <table class="table table-hover">
        <tbody>
        {foreach $items as $item}
          <tr class="text-center">
            <td class="col-md-4"><img src="{$item['MediumImage']['URL']}" alt="{$item['ItemAttributes']['Title']}" width="128" height="128"></td>
            <td class="col-md-6" style="vertical-align: middle">
              <a href="{$item['DetailPageURL']}">
                {$item['ItemAttributes']['Title']}
              </a>
            </td>
            <td class="col-md-2 selectAmazonItem" style="vertical-align: middle">
              <button type="button" class="btn btn-primary">Select item</button>
            </td>
            <td class="productASIN" style="display:none;">
              {$item['ASIN']}
            </td>
            <td class="productTitle" style="display:none;">
              {$item['ItemAttributes']['Title']}
            </td>
          </tr>
        {/foreach}
        </tbody>
      </table>
    </div>
  {/if}
</div>