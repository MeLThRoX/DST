<script>
// @ts-nocheck

	export let name;
	export let products;
    products = products.slice(0, 4)

	const capitalizeFirstLetter = (w) => w.charAt(0).toUpperCase() + w.slice(1);
</script>

<div class="">
	<div class=" bg-slate-800 rounded-md max-w-2xl mx-auto py-16 px-4 sm:py-10 sm:px-6 lg:max-w-7xl lg:px-8">
		<h1 class="text-2xl">{capitalizeFirstLetter(name)}</h1>
		<div class="mt-6 grid grid-cols-1 gap-y-10 gap-x-6 sm:grid-cols-2 lg:grid-cols-4 xl:gap-x-8">
			{#each products as product}
				<div class="group relative">
					<div class="w-full min-h-80 bg-gray-200 aspect-w-1 aspect-h-1 rounded-md overflow-hidden group-hover:opacity-75 lg:h-80 lg:aspect-none">
						<!-- svelte-ignore a11y-img-redundant-alt -->
						<img
							src="https://ipfs.io/ipfs/{product.pictureHash}"
							alt="Image from IPFS"
							class="w-full h-full object-center object-cover lg:w-full lg:h-full"
						/>
					</div>
					<div class="mt-4 flex justify-between">
						<div>
							<h3 class="text-base font-bold text-white">
								<a href="/item/{product.ID}">
									<span aria-hidden="true" class="absolute inset-0" />
									{product.name}
								</a>
							</h3>
							<p class="mt-1 text-sm text-gray-500">{product.description.slice(0, 100)}</p>
						</div>
						<p class="text-base font-medium text-green-300">${product.pricePerUnit}</p>
					</div>
				</div>
			{/each}
		</div>
	</div>
</div>
