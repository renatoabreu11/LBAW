<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Amazon</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<div id="wrapper" class="container">
  <header>
    <h1>Amazon Search</h1>
  </header>
  <main>
    <div>
      <form>
        <div class="row">
          <div class="form-group col-md-2">
            <label for="search_index">Category</label>
            <select class="form-control" name="search_index" id="search_index">
              {foreach $search_indices as $index}
                <option value="{$index}">{$index}</option>
              {/foreach}
            </select>
          </div>
          <div class="input-group col-md-8">
            <input type="text" class="form-control" name="keyword" id="keyword" value="{{$keyword}}" placeholder="Product search">
            <div class="input-group-btn">
              <button class="btn btn-default"><i class="glyphicon glyphicon-search"></i></button>
            </div>
          </div>
        </div>
      </form>
    </div>
    {if $items}
    <div id="results-container">
      {foreach $items as $item}
      <div class="item">
        <div class="item-image-container">
          <img src="{$item.MediumImage.URL}" alt="{$item.ItemAttributes.Title}" class="item-image">
        </div>
        <div class="item-details-container">
          <a href="{$item.DetailPageURL}" class="item-title">
            <strong>{$item.ItemAttributes.Title}</strong>
          </a>
          <div class="item-brand">{$item.ItemAttributes.Brand}</div>
          <div class="item-price">{$item.ItemAttributes.ListPrice.FormattedPrice}</div>
        </div>
      </div>
      {/foreach}
    </div>
    {elseif $has_searched}
    No results found
    {/if}
  </main>
</div>
</body>
</html>