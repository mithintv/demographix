declare global {
	interface String {
		toSentenceCase(): string;
	}
}

String.prototype.toSentenceCase = function () {
	return `${this[0].toUpperCase()}${this.substring(1)}`;
};

export {};
