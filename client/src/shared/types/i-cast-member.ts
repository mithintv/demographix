import { IEthnicity } from "./i-ethnicity";

export interface ICastMember {
	id: number;
	name: string;
	gender: string | null;
	country_of_birth: string | null;
	ethnicities: IEthnicity[];
	races: string[];
}
