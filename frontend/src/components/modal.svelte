<script>
    import { createEventDispatcher, onDestroy } from 'svelte'
    import { fade } from 'svelte/transition'
    import Button from './sButton.svelte'

    const dispatch = createEventDispatcher()
    const close = () => dispatch('close')
    const submit = () => dispatch('submit')

    let modal

    export let title
    export let loading

    const handle_keydown = e => {
        if (e.key === 'Escape') {
            close()
            return
        }
    }
</script>

<svelte:window on:keydown={handle_keydown}/>

<div in:fade out:fade>
    <div class="fixed top-0 left-0 w-full h-full bg-black bg-opacity-80" on:click={close}></div>
    <div role="dialog" aria-modal="true" bind:this={modal} class="absolute left-1/2 top-1/2 w-96 max-w-lg overflow-auto -translate-x-1/2 -translate-y-1/2 bg-slate-900 border-2 border-slate-800 rounded-md">
        <div class="flex flex-col p-3">
            <div class="basis-10 text-2xl pb-3">{title}</div>
            <div class="basis-4/6 border-y-2 border-slate-800 py-3"><slot/></div>
            <div class="basis-10 pt-3 flex justify-end gap-3">
                {#if loading}
                    <Button onclick={() => {}}>
                        <i class="fa-solid fa-spinner-third fa-spin"></i>
                    </Button>
                {:else}
                    <Button onclick={submit} type="success">Submit</Button>
                {/if}
                <Button onclick={close} type="urgent">Abort</Button>
            </div>
        </div>
    </div>
</div>