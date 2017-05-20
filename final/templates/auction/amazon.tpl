<div class="row heading">
  <h3 class="notification-page-title">Amazon Search</h3>
  <p>Search and select here the product that you want to sell, directly from the amazon catalog!</p>
</div>
<div class="input-group col-md-12" style="padding-top: 1em">
  <div class="col-md-7 col-xs-12">
    <input type="text" class="form-control" name="keyword" id="keyword" value="{{$keyword}}" placeholder="Product keyword">
  </div>
  <div class="col-md-3 col-xs-12">
    <select class="selectpicker" data-max-options="1" data-live-search="true" title="Product category..." name="search_index" id="search_index">
      {foreach $searchIndices as $index}
        {if $index == $searchIndex}
          <option value="{$index}" selected>{$index}</option>
        {else}
          <option value="{$index}">{$index}</option>
        {/if}
      {/foreach}
    </select>
  </div>
  <div class="col-md-2 col-xs-12">
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
    <div class="table-responsive">
      <table class="table table-hover">
        <tbody>
        {foreach $items as $item}
          <tr>
            <td class="col-md-2"><img src="" alt="{$item['ItemAttributes']['Title']}"></td>
            <td class="col-md-3">{$item['ItemAttributes']['Title']}<br></td>
          </tr>
        {/foreach}
        </tbody>
      </table>
    </div>
  {/if}
</div>