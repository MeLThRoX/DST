<script>
	import { categories, shop_name } from '../config.json'
	import { cart } from '../cart'
    import { contracts, connected } from 'svelte-ethers-store'

	const capitalizeFirstLetter = w => w.charAt(0).toUpperCase() + w.slice(1)

</script>

<div class="flex flex-row mb-5 pb-5 border-solid border-b border-slate-200 dark:border-slate-800">
	<div class="basis-1/2 font-bold text-2xl"><a href="/">{shop_name}</a></div>
	<div class="basis-1/2 flex flex-row justify-end">
		<div class="flex gap-4 justify-end font-bold">
			{#each categories as category}
				<div><a href="/category/{category}">{capitalizeFirstLetter(category)}</a></div>
			{/each}
		</div>
		<div class="flex items-center space-x-4 border-l pl-6 ml-6 border-solid border-slate-200 dark:border-slate-800">
			{#if $connected}
				{#await $contracts.shop.isAdmin() then isAdmin}
					{#if isAdmin}
						<a href="/admin"><i class="fa-regular fa-user"></i></a>
					{/if}
				{/await}
			{/if}
			<a href="/cart"><i class="fa-regular fa-cart-shopping"></i></a>
			<div class="relative top-2 right-6 bg-slate-600 w-4 h-4 rounded-full text-center text-xs">
				<a href="/cart">{Object.keys($cart).length}</a>
			</div>
		</div>
	</div>
</div>