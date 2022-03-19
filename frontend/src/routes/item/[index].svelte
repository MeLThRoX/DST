<script>
  import Button from '../../components/sButton.svelte';

	import { shop_name } from '../../config.json';
    import { cart } from '../../cart';
	import Page from '../../components/Page.svelte';
	import { page } from '$app/stores';

    import { contracts } from 'svelte-ethers-store'
</script>

<Page>
	{#await $contracts.shop.getProductAtID($page.params.index)}
		<p>Loading Product...</p>
	{:then product} 
		<div class="bg-slate-800 rounded-md p-5">
			<div class="flex flex-row gap-5">
				<!-- svelte-ignore a11y-img-redundant-alt -->
				<img
					src="https://ipfs.io/ipfs/{product.pictureHash}"
					alt="Image from IPFS"
					class="w-50 rounded-md"
				/>
				<div class="flex flex-col w-full justify-between">
					<div class="flex flex-col">
						<h1 class="text-3xl font-bold">{product.name}</h1>
						<p class="mt-1 text-lg text-gray-300">{product.description}</p>
					</div>
					<div class="flex flex-row justify-between">
						<p class="text-4xl font-medium text-green-300">${product.pricePerUnit}</p>
						<Button onclick={() => cart.add(product.ID)}>
							<i class="fa-solid fa-cart-plus"></i>
						</Button>
					</div>
				</div>
			</div>
		</div>
	{/await}
</Page>