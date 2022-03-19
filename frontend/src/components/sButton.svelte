<script lang=ts>
	export let onclick;
	export let type: string = "primary"

	const types = {
		"primary": ["bg-slate-600", "text-white"],
		"urgent": ["bg-red-800", "text-red-200"],
		"success": ["bg-green-800", "text-green-200"],
		"warning": ["bg-yellow-800", "text-yellow-200"]
	}
</script>

<button on:click={onclick} class="w-30 {types[type][0]} {types[type][1]} border border-transparent rounded-md py-3 px-8 flex items-center justify-center text-base font-medium hover:bg-opacity-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500">
	<slot/>
</button>

