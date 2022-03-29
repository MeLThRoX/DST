<script>
// @ts-nocheck

    import { shop_name } from '../../config.json'
    import Page from '../../components/Page.svelte'
    import { page } from '$app/stores';

    import { contracts } from 'svelte-ethers-store'
    let categoryProducts = (products, category) => products.filter(p => p.category == category)

	const capitalizeFirstLetter = (w) => w.charAt(0).toUpperCase() + w.slice(1);
</script>

<svelte:head>
    <title>{shop_name} - {capitalizeFirstLetter($page.params.category)}</title>
</svelte:head>

<Page>
    <h1 class="text-3xl">{capitalizeFirstLetter($page.params.category)}</h1>
    {#await $contracts.shop.getProducts()}
        <p>Loading Produkts...</p>
    {:then products} 
        <div class="grid grid-cols-1 gap-y-10 sm:grid-cols-2 gap-x-6 lg:grid-cols-3 xl:grid-cols-4 xl:gap-x-8">
            {#if categoryProducts(products, $page.params.category).length === 0}
                <p>There are no products in this category.</p>
            {:else} 
                {#each categoryProducts(products, $page.params.category) as product}
                    <a href="/item/{product.ID}" class="group">
                        <div class="w-full aspect-w-1 aspect-h-1 bg-gray-200 rounded-lg overflow-hidden xl:aspect-w-7 xl:aspect-h-8">
                            <!-- svelte-ignore a11y-img-redundant-alt -->
                            <img
                                src="https://ipfs.io/ipfs/{product.pictureHash}"
                                alt="Image from IPFS"
                                class="w-full h-full object-center object-cover group-hover:opacity-75"
                            />
                        </div>
                        <div class="flex mt-2 justify-between">
                            <h3 class="text-lg font-bold text-white">${product.name}</h3>
                            <p class="text-lg font-medium text-green-300">${product.pricePerUnit}</p>
                        </div>
                        <div>
                            <p class="mt-1 text-sm text-gray-500">{product.description}</p>
                        </div>
                    </a>
                {/each}
            {/if}
        </div>
    {/await}
</Page>