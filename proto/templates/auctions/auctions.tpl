{include file='common/header.tpl'}

<div class="container">
  <div class="row">

    <div class="col-md-12">
      <div class="grid search">
        <div class="grid-body">
          <div class="row">
            <div class="col-md-3 hidden-xs">
              <h2 class="grid-title"> Filters</h2>
              <hr>

              <button type="button" class="btn btn-info btn-block" data-toggle="collapse" data-target="#categories">Category</button>

              <div class="collapse" id="categories">
              	{foreach $categories as $category}
				<div class="checkbox">
					<label><input type="checkbox" class="category">{$category.unnest}</label>
				</div>
            	{/foreach}
              </div>

              <div class="padding"></div>

              <button type="button" class="btn btn-info btn-block" data-toggle="collapse" data-target="#price">Price</button>
              <div class="collapse" id="price">
              	<b>From:</b>
			      <select class="form-control" id="fromPrice">
			        <option value="0" selected="selected">0 €</option>
			        <option value="10">10 €</option>
			        <option value="50">50 €</option>
			        <option value="100">100 €</option>
			        <option value="250">250 €</option>
			        <option value="500">500 €</option>
			        <option value="1000">1000 €</option>
			      </select>
			      <b>To:</b>
			      <select class="form-control" id="toPrice">
			        <option value="0">0 €</option>
			        <option value="10">10 €</option>
			        <option value="50">50 €</option>
			        <option value="100">100 €</option>
			        <option value="250">250 €</option>
			        <option value="500">500 €</option>
			        <option value="1000" selected="selected">1000 €</option>
			      </select>
			      <br>
              </div>

              <div class="padding"></div>

              <button type="button" class="btn btn-info btn-block" data-toggle="collapse" data-target="#type">Type</button>
              <div class="collapse" id="type">
              	Not defined!!!
              </div>

              <div class="padding"></div>

              <button type="button" class="btn btn-info btn-block" data-toggle="collapse" data-target="#timeRemaining">Time remaining</button>
              <div class="collapse" id="timeRemaining">
                <b>From</b>
				<select class="form-control" id="fromTimeRem">
					<option value="0" selected="selected">now</option>
					<option value="1800">30 minutes</option>
			        <option value="3600">1 hour</option>
			        <option value="86400">1 day</option>
			        <option value="604800">1 week</option>
			    </select>
			    <b>To</b>
				<select class="form-control" id="toTimeRem">
					<option value="1800">30 minutes</option>
			        <option value="3600" selected="selected">1 hour</option>
			        <option value="86400">1 day</option>
			        <option value="604800">1 week</option>
			    </select>
            </div>




{include file='common/footer.tpl'}