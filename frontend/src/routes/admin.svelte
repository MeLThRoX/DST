<script lang="ts">
    import Page from "../components/Page.svelte"
    import Button from "../components/sButton.svelte"
    import Modal from "../components/modal.svelte"
    import { contracts } from "svelte-ethers-store"
    import { writable } from "svelte/store"

    let showModal = false
    let addProductsLoading = writable(false)
    let currentProduct: number = 0
    let addProductArray: Array<[category: string, name: string, pricePerUnit: number, amount: number, description: string, pictureHash: string]> = [["", "", 0, 0, "", ""]]
    const submitProducts = async () => {
        addProductsLoading.set(true)
        await $contracts.shop.createItems(addProductArray)
        addProductsLoading.set(false)
        addProductArray = [["", "", 0, 0, "", ""]]
        showModal = false
    }
</script>

<Page>
    {#if showModal}
        <Modal on:submit={submitProducts} on:close={() => {showModal = false}} title="Add Products" loading={$addProductsLoading}>
            <div class="flex gap-3">
                <div class="basis-96 flex flex-col text-white gap-3 ">
                    <input class="bg-slate-700 p-3 rounded-md" type="text" placeholder="Category" bind:value={addProductArray[currentProduct][0]}>
                    <input class="bg-slate-700 p-3 rounded-md" type="text" placeholder="Name" bind:value={addProductArray[currentProduct][1]}>
                    <input class="bg-slate-700 p-3 rounded-md" type="number" bind:value={addProductArray[currentProduct][2]}>
                    <input class="bg-slate-700 p-3 rounded-md" type="number" bind:value={addProductArray[currentProduct][3]}>
                    <input class="bg-slate-700 p-3 rounded-md" type="text" placeholder="Description" bind:value={addProductArray[currentProduct][4]}>
                    <input class="bg-slate-700 p-3 rounded-md" type="text" placeholder="Picture Hash" bind:value={addProductArray[currentProduct][5]}>
                </div>
                <div class="basis-9 flex flex-col justify-end gap-3">
                    <p>Index: {currentProduct}</p>
                    {#if currentProduct !== 0}
                        <Button onclick={() => {addProductArray.splice(currentProduct, 1); currentProduct--}} type="urgent"><i class="fa-solid fa-trash"></i></Button>
                        <Button onclick={() => {currentProduct--}}><i class="fa-solid fa-arrow-left"></i></Button>
                    {/if}
                    {#if currentProduct === addProductArray.length-1}
                        <Button onclick={() => {currentProduct++; addProductArray.push(["", "", 0, 0, "", ""])}}><i class="fa-solid fa-plus"></i></Button>
                    {:else}
                        <Button onclick={() => {currentProduct++}}><i class="fa-solid fa-arrow-right"></i></Button>
                    {/if}
                </div>
            </div>
        </Modal>
    {/if}
    <div class="flex flex-col gap-5">
        <h1 class="text-3xl">Admin Management</h1>
        <div class="bg-slate-800 rounded-md p-5">
            <div class="flex justify-between border-2 border-slate-900 p-4 rounded-md">
                {#await $contracts.shop.getProducts()}
                    <p>Loading...</p>
                {:then products} 
                    <p class="text-2xl font-medium my-auto">Number of products: {products.length}</p>
                {/await}
                <Button onclick={() => showModal = true}>Add Products</Button>
            </div>
        </div>
    </div>
</Page>