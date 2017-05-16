{include file = 'common/header.tpl'}

<div class="container" style="margin-bottom: 80px;">
	<div class="row">
		<div class="col-md-12">
			<ul class="breadcrumb">
				<li>
					<a href="{$BASE_URL}pages/auctions/best_auctions.php">Home</a> <span class="divider"></span>
				</li>
				<li class="active">
					Credit info
				</li>
			</ul>
		</div>
	</div>
	<div class="row" style="margin-bottom: 50px;">
		<div class="col-sm-12 col-md-4">
			<div class="hero-widget well well-sm">
				<div class="icon">
					<i class="glyphicon glyphicon-piggy-bank"></i>
				</div>
				<div class="text">
					<var id="currCredit" data-currCredit="{$currCredit}">{$currCredit} €</var>
					<label class="text-muted">Current credit</label>
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4">
			<div class="hero-widget well well-sm">
				<div class="icon">
					<i class="glyphicon glyphicon-flash"></i>
				</div>
				<div class="text">
					<var>{$numBetsOnGame}</var>
					<label class="text-muted">Number of bets on game</label>
				</div>
			</div>
		</div>
		<div class="col-sm-12 col-md-4">
			<div class="hero-widget well well-sm">
				<div class="icon">
					<i class="glyphicon glyphicon-shopping-cart"></i>
				</div>
				<div class="text">
					<var>{$valBetsOnGame} €</var>
					<label class="text-muted">Value of bets on game</label>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-4"></div>
		<div class="col-xs-4">
			<label class="sr-only" for="creditToAdd">Credit</label>
			<div class="input-group number-spinner">
				<span class="input-group-btn">
					<button class="btn btn-default" data-dir="dwn"><span class="glyphicon glyphicon-minus"></span></button>
				</span>
				<input type="text" id="creditToAdd" class="form-control text-center" value="100">
				<span class="input-group-btn">
					<button class="btn btn-default" data-dir="up"><span class="glyphicon glyphicon-plus"></span></button>
				</span>
			</div>
			<div class="col-xs-12 text-center" style="padding-top: 1em">
				<button id="addCreditBtn" class="btn btn-primary active text-center">Add credit to your account</button>
			</div>
		</div>
		<div class="col-xs-4"></div>
	</div>
</div>

<script src="{$BASE_URL}javascript/credit.js"></script>

{include file = 'common/footer.tpl'}