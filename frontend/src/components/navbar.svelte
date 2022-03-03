<script>
	import { categories, shop_name } from '../config.json'
	const capitalizeFirstLetter = w => w.charAt(0).toUpperCase() + w.slice(1)
</script>

<div class="flex flex-row my-5 py-5 border-solid border-b border-slate-200 dark:border-slate-800">
	<div class="basis-1/3 font-bold"><a href="/">{shop_name}</a></div>
	<div class="basis-1/2 flex gap-4 justify-end font-bold">
		{#each categories as categorie}
			<div><a href="/category/{categorie}">{capitalizeFirstLetter(categorie)}</a></div>
		{/each}
	</div>
	<div class="basis-1/6 flex items-center space-x-4 border-l pl-6 ml-6 border-solid border-slate-200 dark:border-slate-800">
		<div><a href="/profile">Profile</a></div>
		<div><a href="/cart">Cart</a></div>
	</div>
</div>
